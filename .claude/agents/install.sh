#!/usr/bin/env bash
# Install Dev-Company at the USER level so the whole company is available in
# EVERY Claude Code project on this machine/account.
#
# It does two things:
#   1. Copies every agent definition to ~/.claude/agents/ and installs the
#      /dev-company skill to ~/.claude/skills/dev-company/
#   2. Installs/refreshes a managed "Dev-Company" block in ~/.claude/CLAUDE.md
#      so Claude knows to route to the CEO when you summon the company.
#
# Usage:  bash install.sh
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SRC_DIR/../.." && pwd)"
CLAUDE_DIR="${CLAUDE_HOME:-$HOME/.claude}"
DEST_DIR="$CLAUDE_DIR/agents"
SKILL_DIR="$CLAUDE_DIR/skills"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"

mkdir -p "$DEST_DIR" "$SKILL_DIR"

# 1) Install agents (skip README).
count=0
for f in "$SRC_DIR"/*.md; do
  base="$(basename "$f")"
  [ "$base" = "README.md" ] && continue
  cp "$f" "$DEST_DIR/$base"
  count=$((count + 1))
done
echo "Installed $count company agents to $DEST_DIR"

# 1b) Install the /dev-company skill (available in every project). It replaces
#     the older commands/ file, which is removed so the two never conflict.
if [ -f "$REPO_ROOT/.claude/skills/dev-company/SKILL.md" ]; then
  mkdir -p "$SKILL_DIR/dev-company"
  cp "$REPO_ROOT/.claude/skills/dev-company/SKILL.md" "$SKILL_DIR/dev-company/SKILL.md"
  rm -f "$CLAUDE_DIR/commands/dev-company.md"
  echo "Installed /dev-company skill to $SKILL_DIR/dev-company"
fi

# 2) Install/refresh the managed routing block in ~/.claude/CLAUDE.md.
BEGIN="<!-- BEGIN DEV-COMPANY (managed block) -->"
END="<!-- END DEV-COMPANY (managed block) -->"

read -r -d '' BLOCK <<'BLOCKEOF' || true
<!-- BEGIN DEV-COMPANY (managed block) -->
# Dev-Company — available in every project

A full virtual technology & cybersecurity company is installed as Claude Code
agents at the user level (~/.claude/agents/), available in every project. Led
by a CEO that reports to the owner and delegates to every department.

When the user refers to "Dev-Company", "the company", "the team", "CEO", or
asks for end-to-end / multi-discipline / strategic work, route to the `ceo`
agent by default. If they name a specialist (e.g. `appsec-engineer`,
`cloud-architect`), go straight to that agent. For a trivial one-off, just
answer. This routing is opt-in: don't force the company onto unrelated
requests. The owner holds final approval on anything irreversible,
external-facing, or high-cost.

Security posture: defense-first. Offensive security work (red team / pentest)
runs only against systems the owner owns or is authorized in writing to test,
gated by the CISO (`ciso`) and `legal-counsel`.
<!-- END DEV-COMPANY (managed block) -->
BLOCKEOF

touch "$CLAUDE_MD"
if grep -qF "$BEGIN" "$CLAUDE_MD"; then
  # Replace the existing managed block, leaving the rest of the file untouched.
  tmp="$(mktemp)"
  awk -v b="$BEGIN" -v e="$END" '
    $0==b {skip=1}
    skip==0 {print}
    $0==e {skip=0}
  ' "$CLAUDE_MD" > "$tmp"
  printf '%s\n' "$BLOCK" >> "$tmp"
  mv "$tmp" "$CLAUDE_MD"
  echo "Refreshed Dev-Company block in $CLAUDE_MD"
else
  { [ -s "$CLAUDE_MD" ] && echo; printf '%s\n' "$BLOCK"; } >> "$CLAUDE_MD"
  echo "Added Dev-Company block to $CLAUDE_MD"
fi

echo
echo "Done. The company (CEO + departments) is now available in any Claude Code project."
echo "Summon it with:  /dev-company <task>  ·  \"CEO, ...\"  ·  or call a specialist by name."
