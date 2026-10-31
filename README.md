# my-claude-skills

GitHub-hosted Claude plugin marketplace. Add this repo once in each Claude account; skill updates ship when you bump the version and push.

## Add this marketplace in Claude

1. Open **Customize → Plugins → + → Add marketplace → Add from a repository**
2. Paste: `https://github.com/mUsman3/my-claude-skills`
3. Install the **my-skills** plugin
4. Start a new chat

## Add a skill

1. Create a folder under `plugins/my-skills/skills/<skill-name>/` (lowercase, hyphen-separated, max 64 chars)
2. Add `SKILL.md` with YAML frontmatter:

```markdown
---
name: skill-name
description: Use when … (one sentence — this drives when Claude triggers the skill)
---

Skill instructions go here.
```

3. Optional supporting dirs: `scripts/`, `references/`, `assets/`
4. Bump the version, commit, and push (below)

## Bump version after any skill change

Claude only picks up marketplace updates when the plugin version changes. Keep `marketplace.json` and `plugin.json` in sync:

```bash
./scripts/bump-version.sh        # patch (default)
./scripts/bump-version.sh minor
./scripts/bump-version.sh major
```

Then:

```bash
git add -A
git commit -m "Describe the skill change"
git push
```

In **each** Claude account: open the marketplace’s **···** menu → **Check for updates**, then start a **new chat**.

If an update seems stuck, remove the marketplace and re-add it (known desktop sync bug).

## Verify sync

Say `sync check` — you should get `SYNC TEST — version N` matching the current `sync-test` skill body.
