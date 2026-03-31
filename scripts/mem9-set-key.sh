#!/usr/bin/env bash
set -euo pipefail

KEY_FILE="${MEM9_KEY_FILE:-.mem9-api-key}"

if [[ $# -lt 1 ]]; then
  echo "Usage: scripts/mem9-set-key.sh <mem9_api_key>" >&2
  exit 1
fi

API_KEY="$1"
printf "%s" "$API_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"

echo "Saved API key to $KEY_FILE with mode 600."
echo "Keep this key private. Anyone with it can access your mem9 memory."
