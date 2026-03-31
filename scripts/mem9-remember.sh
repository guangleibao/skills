#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: scripts/mem9-remember.sh <content> [tags_csv] [source]" >&2
  exit 1
fi

CONTENT="$1"
TAGS="${2:-session}"
SOURCE="${3:-cursor-agent}"

scripts/mem9-cli.sh store "$CONTENT" "$TAGS" "$SOURCE"
echo ""
echo "Latest operation log entry:"
scripts/mem9-cli.sh ops 1
