#!/usr/bin/env bash
set -euo pipefail

# Default trailing window policy: 8 days.
DEFAULT_DAYS="${MEM9_TRAILING_DAYS:-8}"
DEFAULT_LIMIT="${MEM9_RECALL_LIMIT:-20}"

if [[ $# -eq 0 ]]; then
  scripts/mem9-cli.sh recent "$DEFAULT_DAYS" "$DEFAULT_LIMIT"
  exit 0
fi

QUERY="$1"
DAYS="${2:-$DEFAULT_DAYS}"
LIMIT="${3:-$DEFAULT_LIMIT}"

scripts/mem9-cli.sh search_recent "$QUERY" "$DAYS" "$LIMIT"
