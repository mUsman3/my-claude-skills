#!/usr/bin/env bash
# Publish skill changes to every Claude account.
# Bumps the plugin version, commits, and pushes to GitHub.
# Usage: ./scripts/publish.sh "what changed" [patch|minor|major]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MSG="${1:-}"
BUMP="${2:-patch}"

if [[ -z "$MSG" ]]; then
  echo "Usage: ./scripts/publish.sh \"what changed\" [patch|minor|major]" >&2
  exit 1
fi

cd "$ROOT"

if [[ -z "$(git status --porcelain)" ]]; then
  echo "Nothing to publish. Edit a skill under plugins/my-skills/skills/ first." >&2
  exit 1
fi

"$ROOT/scripts/bump-version.sh" "$BUMP"
VERSION="$(jq -r '.plugins[0].version' "$ROOT/.claude-plugin/marketplace.json")"

git add -A
git commit -m "$MSG"
git push

echo "Published my-skills ${VERSION}."
echo "On each Claude account: marketplace ··· → Check for updates, then start a new chat."
