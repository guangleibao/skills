---
name: mem9-local-bridge
description: Use local mem9 scripts for persistent memory without OpenClaw plugin runtime. Trigger when the user asks to save facts for later, recall prior facts, search memory, or use mem9/manual memory integration in this project.
---

# mem9 Local Bridge

Use this skill to read/write persistent memory in mem9 via local scripts, without requiring OpenClaw installation.
This skill is the default memory behavior for this workspace.

## When to use

- User asks to remember/save/retrieve/delete long-term facts.
- User asks to use mem9 in this local project.
- User asks to import existing memory/session files into mem9.
- Agent appears to be in a fresh/new context and needs continuity.

## Security rules

- Treat mem9 API key as a secret.
- Never print the full key in normal output.
- Prefer `MEM9_API_KEY` env var or `.mem9-api-key` local file.
- If `.mem9-api-key` is used, keep file mode at `600`.

## Local commands

Run from workspace root:

```bash
scripts/mem9-cli.sh health
scripts/mem9-cli.sh list 10
scripts/mem9-cli.sh recent 8 20
scripts/mem9-cli.sh search "keyword" 10
scripts/mem9-cli.sh search_recent "keyword" 8 20
scripts/mem9-cli.sh store "fact text" "tag1,tag2" "local-cli"
scripts/mem9-cli.sh update "<memory_id>" "updated fact text" "tag1,tag2" "local-cli"
scripts/mem9-cli.sh get "<memory_id>"
scripts/mem9-cli.sh delete "<memory_id>"
scripts/mem9-cli.sh import "./memory.json" memory
scripts/mem9-cli.sh import "./sessions/s1.json" session s1
scripts/mem9-cli.sh ops 20
scripts/mem9-remember.sh "fact text" "tag1,tag2" "cursor-agent"
scripts/mem9-recall.sh
scripts/mem9-recall.sh "keyword"
```

Set key one-time into local secure file:

```bash
scripts/mem9-set-key.sh "<mem9-api-key>"
```

Alternative:

```bash
export MEM9_API_KEY="<mem9-api-key>"
```

## Execution workflow

1. If context is lost/new, run recall first:
   - `scripts/mem9-recall.sh` (default trailing 8 days).
2. Confirm user intent: store, search, update, import, or delete.
3. Ensure key is configured (`MEM9_API_KEY` or `.mem9-api-key`).
4. Execute `scripts/mem9-cli.sh` command matching intent.
5. During normal sessions, persist useful durable facts with:
   - `scripts/mem9-remember.sh "..."`
6. After each write operation, report changes by reading:
   - `scripts/mem9-cli.sh ops 20`
   and summarize what was saved, updated, or deleted.
7. For destructive operations (`delete`), ask confirmation first unless user already explicitly requested it.

## Response style for memory actions

- For store/update/delete: include operation report:
  - saved memories
  - updated memories
  - deleted memories
- For search/list: show top matches (id + short content excerpt).
- For recalls in this workspace: prefer trailing 8-day results unless user asks a different window.
- For failures: provide exact fix step (missing key, missing jq, network issue).
