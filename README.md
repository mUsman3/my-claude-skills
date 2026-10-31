# my-claude-skills

One GitHub repo is the shared copy of your skills. Every Claude account installs it and downloads updates from here. Accounts do not copy skills to each other.

Repo: https://github.com/mUsman3/my-claude-skills

## Once per Claude account

1. Customize → Plugins → + → Add marketplace → Add from a repository
2. Paste `https://github.com/mUsman3/my-claude-skills`
3. Click **Add** on **My skills**
4. New chat, type `sync check`. Expect `SYNC TEST — version 1`

## Every time you change a skill

Edit only in this folder: `plugins/my-skills/skills/<skill-name>/SKILL.md`

Then publish:

```bash
./scripts/publish.sh "what changed"
```

That bumps the version in both JSON files, commits, and pushes. Claude ignores a skill edit until the version changes.

On each Claude account: marketplace **···** → **Check for updates**, then start a **new chat**.

If an update stays on the old text, remove the marketplace and add it again.

## Add a skill

Create `plugins/my-skills/skills/<skill-name>/SKILL.md`. The folder name is lowercase and hyphen-separated, at most 64 characters. `name` in the frontmatter must match the folder.

```markdown
---
name: skill-name
description: Use when … (one sentence — this is when Claude should use the skill)
---

Instructions.
```

Optional folders next to `SKILL.md`: `scripts/`, `references/`, `assets/`.

Then run `./scripts/publish.sh "Add skill-name"`.
