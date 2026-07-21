---
name: example
description: Placeholder skill demonstrating the ~/.agents/skills/ pattern. Use ONLY as a template — delete or replace before relying on it.
---

# Example skill

Starter skill showing the layout opencode auto-loads from `~/.agents/skills/<name>/SKILL.md`.

To create a new skill:

1. Add a folder under `agents/skills/<name>/` in this dotfiles repo.
2. Put a `SKILL.md` file in it with frontmatter (`name`, `description` are required).
3. Re-run `./run/setup.sh` (or `stow --target=$HOME/.agents -d . agents`).
4. Quit and restart opencode to pick it up.

When you're ready, delete this folder.
