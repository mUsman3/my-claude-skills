#!/usr/bin/env bash
# Bump plugin version in marketplace.json and plugin.json (must stay in sync).
# Usage: ./scripts/bump-version.sh [patch|minor|major]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MARKETPLACE="$ROOT/.claude-plugin/marketplace.json"
PLUGIN="$ROOT/plugins/my-skills/.claude-plugin/plugin.json"
BUMP="${1:-patch}"

if [[ ! "$BUMP" =~ ^(patch|minor|major)$ ]]; then
  echo "Usage: $0 [patch|minor|major]" >&2
  exit 1
fi

bump_semver() {
  local version="$1" part="$2"
  local major minor patch
  IFS=. read -r major minor patch <<<"$version"
  major="${major:-0}"
  minor="${minor:-0}"
  patch="${patch:-0}"
  case "$part" in
    major) major=$((major + 1)); minor=0; patch=0 ;;
    minor) minor=$((minor + 1)); patch=0 ;;
    patch) patch=$((patch + 1)) ;;
  esac
  echo "${major}.${minor}.${patch}"
}

if command -v jq >/dev/null 2>&1; then
  CURRENT="$(jq -r '.plugins[0].version' "$MARKETPLACE")"
  PLUGIN_VER="$(jq -r '.version' "$PLUGIN")"
  if [[ "$CURRENT" != "$PLUGIN_VER" ]]; then
    echo "Error: versions out of sync before bump (marketplace=$CURRENT, plugin=$PLUGIN_VER)" >&2
    exit 1
  fi
  NEW="$(bump_semver "$CURRENT" "$BUMP")"
  tmp="$(mktemp)"
  jq --arg v "$NEW" '.plugins[0].version = $v' "$MARKETPLACE" >"$tmp" && mv "$tmp" "$MARKETPLACE"
  tmp="$(mktemp)"
  jq --arg v "$NEW" '.version = $v' "$PLUGIN" >"$tmp" && mv "$tmp" "$PLUGIN"
else
  CURRENT="$(python3 -c "import json; print(json.load(open('$MARKETPLACE'))['plugins'][0]['version'])")"
  PLUGIN_VER="$(python3 -c "import json; print(json.load(open('$PLUGIN'))['version'])")"
  if [[ "$CURRENT" != "$PLUGIN_VER" ]]; then
    echo "Error: versions out of sync before bump (marketplace=$CURRENT, plugin=$PLUGIN_VER)" >&2
    exit 1
  fi
  NEW="$(bump_semver "$CURRENT" "$BUMP")"
  python3 - "$MARKETPLACE" "$PLUGIN" "$NEW" <<'PY'
import json, sys
marketplace, plugin, new = sys.argv[1:4]
with open(marketplace) as f:
    data = json.load(f)
data["plugins"][0]["version"] = new
with open(marketplace, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
with open(plugin) as f:
    data = json.load(f)
data["version"] = new
with open(plugin, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
fi

echo "$NEW"
