# Dotfiles symlinked on my machine

### Install with stow:
```bash
stow .
```

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
