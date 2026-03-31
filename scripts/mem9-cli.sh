#!/usr/bin/env bash
set -euo pipefail

API_BASE="${MEM9_API_BASE:-https://api.mem9.ai}"
API_V2="$API_BASE/v1alpha2/mem9s"
KEY_FILE="${MEM9_KEY_FILE:-.mem9-api-key}"
OPS_LOG_FILE="${MEM9_OPS_LOG_FILE:-.mem9-ops.log}"

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

load_api_key() {
  if [[ -n "${MEM9_API_KEY:-}" ]]; then
    API_KEY="$MEM9_API_KEY"
    return 0
  fi

  if [[ -f "$KEY_FILE" ]]; then
    API_KEY="$(tr -d '\r\n' < "$KEY_FILE")"
    if [[ -n "$API_KEY" ]]; then
      return 0
    fi
  fi

  echo "No API key found." >&2
  echo "Set MEM9_API_KEY or create $KEY_FILE (use scripts/mem9-set-key.sh)." >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage:
  scripts/mem9-cli.sh health
  scripts/mem9-cli.sh list [limit]
  scripts/mem9-cli.sh recent [days] [limit]
  scripts/mem9-cli.sh search <query> [limit]
  scripts/mem9-cli.sh search_recent <query> [days] [limit]
  scripts/mem9-cli.sh store <content> [tags_csv] [source]
  scripts/mem9-cli.sh update <memory_id> <content> [tags_csv] [source]
  scripts/mem9-cli.sh get <memory_id>
  scripts/mem9-cli.sh delete <memory_id>
  scripts/mem9-cli.sh import <file_path> <memory|session> [session_id]
  scripts/mem9-cli.sh ops [count]

Examples:
  scripts/mem9-cli.sh list 10
  scripts/mem9-cli.sh recent 8 20
  scripts/mem9-cli.sh search "postgres" 5
  scripts/mem9-cli.sh search_recent "postgres" 8 10
  scripts/mem9-cli.sh store "User prefers dark theme" "prefs,ui" "local-cli"
EOF
}

epoch_days_ago() {
  local days="$1"
  python3 - "$days" <<'PY'
import sys, time
days = int(sys.argv[1])
print(int(time.time()) - days * 86400)
PY
}

filter_recent() {
  local days="$1"
  local cutoff
  cutoff="$(epoch_days_ago "$days")"
  jq --argjson cutoff "$cutoff" '
    def items:
      if type == "array" then .
      elif (has("memories") and (.memories|type) == "array") then .memories
      elif (has("items") and (.items|type) == "array") then .items
      elif (has("data") and (.data|type) == "array") then .data
      else [] end;
    def ts:
      (.updatedAt // .updated_at // .createdAt // .created_at // null);
    items
    | map(. + { _ts: ((ts | fromdateiso8601?) // 0) })
    | map(select(._ts >= $cutoff))
    | map(del(._ts))
  '
}

log_op() {
  local op="$1"
  local id="$2"
  local content="${3:-}"
  local source="${4:-}"
  local now_iso
  now_iso="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  jq -cn \
    --arg t "$now_iso" \
    --arg op "$op" \
    --arg id "$id" \
    --arg c "$content" \
    --arg s "$source" \
    '{time:$t,op:$op,id:$id,content:$c,source:$s}' >> "$OPS_LOG_FILE"
}

request() {
  local method="$1"
  local url="$2"
  local data="${3:-}"
  if [[ -n "$data" ]]; then
    curl -sS -X "$method" \
      -H "X-API-Key: $API_KEY" \
      -H "Content-Type: application/json" \
      -d "$data" \
      "$url"
  else
    curl -sS -X "$method" \
      -H "X-API-Key: $API_KEY" \
      "$url"
  fi
}

cmd_health() {
  curl -sS "$API_BASE/healthz" | jq .
}

cmd_list() {
  local limit="${1:-10}"
  request GET "$API_V2/memories?limit=$limit" | jq .
}

cmd_recent() {
  local days="${1:-8}"
  local limit="${2:-50}"
  request GET "$API_V2/memories?limit=$limit" | filter_recent "$days" | jq .
}

cmd_search() {
  if [[ $# -lt 1 ]]; then
    echo "search requires <query>" >&2
    usage
    exit 1
  fi
  local q="$1"
  local limit="${2:-10}"
  local encoded_q
  encoded_q="$(jq -rn --arg v "$q" '$v|@uri')"
  request GET "$API_V2/memories?q=$encoded_q&limit=$limit" | jq .
}

cmd_search_recent() {
  if [[ $# -lt 1 ]]; then
    echo "search_recent requires <query>" >&2
    usage
    exit 1
  fi
  local q="$1"
  local days="${2:-8}"
  local limit="${3:-50}"
  local encoded_q
  encoded_q="$(jq -rn --arg v "$q" '$v|@uri')"
  request GET "$API_V2/memories?q=$encoded_q&limit=$limit" | filter_recent "$days" | jq .
}

cmd_store() {
  if [[ $# -lt 1 ]]; then
    echo "store requires <content>" >&2
    usage
    exit 1
  fi
  local content="$1"
  local tags_csv="${2:-}"
  local source="${3:-local-cli}"
  local payload

  if [[ -n "$tags_csv" ]]; then
    payload="$(jq -cn --arg c "$content" --arg t "$tags_csv" --arg s "$source" '{content:$c,tags:($t|split(",")),source:$s}')"
  else
    payload="$(jq -cn --arg c "$content" --arg s "$source" '{content:$c,source:$s}')"
  fi

  local result
  result="$(request POST "$API_V2/memories" "$payload")"
  local id
  id="$(echo "$result" | jq -r '.id // .memory.id // ""')"
  log_op "store" "$id" "$content" "$source"
  echo "$result" | jq .
}

cmd_update() {
  if [[ $# -lt 2 ]]; then
    echo "update requires <memory_id> <content>" >&2
    usage
    exit 1
  fi
  local memory_id="$1"
  local content="$2"
  local tags_csv="${3:-}"
  local source="${4:-local-cli}"
  local payload

  if [[ -n "$tags_csv" ]]; then
    payload="$(jq -cn --arg c "$content" --arg t "$tags_csv" --arg s "$source" '{content:$c,tags:($t|split(",")),source:$s}')"
  else
    payload="$(jq -cn --arg c "$content" --arg s "$source" '{content:$c,source:$s}')"
  fi

  local result
  result="$(request PUT "$API_V2/memories/$memory_id" "$payload")"
  log_op "update" "$memory_id" "$content" "$source"
  echo "$result" | jq .
}

cmd_get() {
  if [[ $# -lt 1 ]]; then
    echo "get requires <memory_id>" >&2
    usage
    exit 1
  fi
  request GET "$API_V2/memories/$1" | jq .
}

cmd_delete() {
  if [[ $# -lt 1 ]]; then
    echo "delete requires <memory_id>" >&2
    usage
    exit 1
  fi
  local memory_id="$1"
  local result
  result="$(request DELETE "$API_V2/memories/$memory_id")"
  log_op "delete" "$memory_id" ""
  echo "$result" | jq .
}

cmd_import() {
  if [[ $# -lt 2 ]]; then
    echo "import requires <file_path> <memory|session> [session_id]" >&2
    usage
    exit 1
  fi
  local file_path="$1"
  local file_type="$2"
  local session_id="${3:-}"

  if [[ ! -f "$file_path" ]]; then
    echo "File not found: $file_path" >&2
    exit 1
  fi
  if [[ "$file_type" != "memory" && "$file_type" != "session" ]]; then
    echo "file_type must be 'memory' or 'session'" >&2
    exit 1
  fi

  local args=(-sS -X POST "$API_V2/imports" -H "X-API-Key: $API_KEY" -F "file=@$file_path" -F "file_type=$file_type")
  if [[ "$file_type" == "session" && -n "$session_id" ]]; then
    args+=(-F "session_id=$session_id")
  fi
  curl "${args[@]}" | jq .
}

cmd_ops() {
  local count="${1:-20}"
  if [[ ! -f "$OPS_LOG_FILE" ]]; then
    echo "[]" | jq .
    return 0
  fi
  tail -n "$count" "$OPS_LOG_FILE" | jq -s .
}

main() {
  need_cmd curl
  need_cmd jq
  need_cmd python3

  local cmd="${1:-}"
  if [[ -z "$cmd" ]]; then
    usage
    exit 1
  fi

  case "$cmd" in
    health)
      cmd_health
      ;;
    list|recent|search|search_recent|store|update|get|delete|import|ops)
      load_api_key
      shift
      "cmd_${cmd}" "$@"
      ;;
    -h|--help|help)
      usage
      ;;
    *)
      echo "Unknown command: $cmd" >&2
      usage
      exit 1
      ;;
  esac
}

main "$@"
