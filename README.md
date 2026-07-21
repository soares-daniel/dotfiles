# Dotfiles symlinked on my machine

### Install with stow:
```bash
stow .
```

Or use the helper script (handles conflicts, preflight, ownership):
```bash
./run/setup.sh
```

### Top-level stow packages
| Package | Target | Purpose |
| --- | --- | --- |
| `.config/` | `~/.config/` | Tracked config directories (nvim, tmux, wezterm, zsh, …) |
| `bashrc/`, `zshrc/` | `~/` | Shell rc symlinks (created by `run/setup.sh`) |
| `.local/` | `~/.local/` | User scripts and binaries |
| `opencode/` | `~/.config/opencode/` | OpenCode config JSONs (plugin-managed `skills/` is gitignored) |
| `agents/` | `~/.agents/` | Personal skills auto-loaded by opencode from `~/.agents/skills/<name>/SKILL.md` |

Adding a new skill: create `agents/skills/<name>/SKILL.md`, then re-run `./run/setup.sh` (or `stow --target=$HOME/.agents -d . agents`) and restart opencode.

### Swaylock custom auth (system-level)
These files are versioned under `run/` for reproducible setup on a new machine:

- `run/swaylock.pam` → installs to `/etc/pam.d/swaylock`
- `run/swaylock-setpass` → installs to `/usr/local/sbin/swaylock-setpass`
- `run/install-swaylock-auth.sh` → installer script (requires sudo)

Install on a new Ubuntu machine:

```bash
sudo ./run/install-swaylock-auth.sh
sudo /usr/local/sbin/swaylock-setpass <your-username>
```

Behavior:

- `swaylock` accepts custom password DB first (`pam_userdb`)
- then falls back to system login password (`auth include login`)
