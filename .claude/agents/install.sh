#!/usr/bin/env bash
# Install the Dev-Company agents at the user level so the whole company is
# available in EVERY Claude Code project on this machine/account.
#
# Usage:  bash install.sh
#
# It copies every agent definition in this directory to ~/.claude/agents/.
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="${CLAUDE_HOME:-$HOME/.claude}/agents"

mkdir -p "$DEST_DIR"

count=0
for f in "$SRC_DIR"/*.md; do
  base="$(basename "$f")"
  # Don't install the README as an agent.
  [ "$base" = "README.md" ] && continue
  cp "$f" "$DEST_DIR/$base"
  count=$((count + 1))
done

echo "Installed $count company agents to $DEST_DIR"
echo "The company (CEO + departments) is now available in any Claude Code project."
echo "Start with:  \"CEO, ...\"  or call a specialist agent by name."
