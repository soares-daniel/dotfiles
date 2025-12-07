#!/usr/bin/env bash
set -euo pipefail

if command -v git >/dev/null 2>&1; then
  REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null || true)"
  if [[ -z "${REPO_DIR:-}" || ! -d "$REPO_DIR/.git" ]]; then
    REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  fi
else
  REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
fi
if [[ ! -d "$REPO_DIR/.config" ]]; then
  echo "ERROR: Could not find '$REPO_DIR/.config'. REPO_DIR=$REPO_DIR"
  exit 1
fi

is_wsl() { grep -qiE '(microsoft|wsl)' /proc/version 2>/dev/null; }
is_windows() { [[ "${OSTYPE:-}" == msys || "${OSTYPE:-}" == cygwin ]]; }

backup_if_conflict() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv -v "$target" "${target}.bak.$(date +%Y%m%d_%H%M%S)"
  fi
}

stow_pkg() {
  local pkg="$1" target="$2"
  ( cd "$REPO_DIR" && mkdir -p "$target" && stow --target="$target" "$pkg" )
}

preflight_simulate() {
  local pkg="$1" target="$2"
  echo "Preflight (simulate): stow --target=\"$target\" $pkg"
  if ! ( cd "$REPO_DIR" && stow -n -v 1 --target="$target" "$pkg" ) | tee /tmp/stow_simulate.out; then
    echo "ERROR: stow simulation failed."
    return 1
  fi
  if grep -Eiq 'CONFLICT|would not be able to' /tmp/stow_simulate.out; then
    echo "Detected conflicts in simulation. Resolve or let this script back up blockers."
    return 2
  fi
  return 0
}

backup_common_blockers_in_config() {
  # These are common mistakes that end up inside ~/.config and block symlinks
  local items=(
    "$HOME/.config/.bashrc"
    "$HOME/.config/bashrc"
  )
  for p in "${items[@]}"; do
    if [[ -e "$p" && ! -L "$p" ]]; then
      echo "Backing up unexpected existing item that could block stow: $p"
      mv -v "$p" "${p}.bak.$(date +%Y%m%d_%H%M%S)"
    fi
  done
}

echo "Dotfiles repo: $REPO_DIR"

if is_wsl || is_windows; then
  echo "WSL/Windows detected. Copying instead of symlinking."
  rsync -a --info=name0,progress2 \
    --exclude '.git' --exclude '.backup.*' --exclude '.stowrc' \
    "$REPO_DIR/.config/" "$HOME/.config/"

  for f in "$REPO_DIR/bashrc/.bashrc" "$REPO_DIR/zshrc/.zshrc"; do
    [[ -f "$f" ]] || continue
    tgt="$HOME/.$(basename "$f")"
    backup_if_conflict "$tgt"
    install -m 0644 "$f" "$tgt"
  done
  echo "Done (copy mode)."
  exit 0
fi

if [[ "$(id -u)" -eq 0 ]]; then
  echo "Refusing to run as root. Re-run without sudo."
  exit 1
fi

if ! command -v stow >/dev/null 2>&1; then
  echo "Please install stow (e.g., sudo apt-get install stow) and re-run."
  exit 1
fi

echo "Using GNU Stow (symlinks)."

# Ensure ownership of ~/.config to avoid permission issues from past sudo runs
if [[ -d "$HOME/.config" ]]; then
  if ! touch "$HOME/.config/.write_test" 2>/dev/null; then
    echo "Attempting to fix ownership of ~/.config (may prompt for sudo)..."
    sudo chown -R "$USER":"$USER" "$HOME/.config"
  else
    rm -f "$HOME/.config/.write_test"
  fi
fi

# Stow .config meta-package into ~/.config
if [[ -d "$REPO_DIR/.config" ]]; then
  echo "Stowing .config → ~/.config"
  mkdir -p "$HOME/.config"

  backup_common_blockers_in_config

  if preflight_simulate ".config" "$HOME/.config"; then
    stow_pkg ".config" "$HOME/.config"
  else
    echo "Attempting to back up common blockers and retry."
    backup_common_blockers_in_config
    if preflight_simulate ".config" "$HOME/.config"; then
      stow_pkg ".config" "$HOME/.config"
    else
      echo "ERROR: Conflicts remain. Please resolve the above conflicts and re-run."
      exit 1
    fi
  fi
fi

# Now symlink bashrc, zshrc
for pkg in bashrc zshrc; do
  src="$HOME/.config/$pkg/.$pkg"
  dest="$HOME/.$pkg"

  if [[ ! -f "$src" ]]; then
    echo "WARNING: Source file not found: $src — skipping."
    continue
  fi

  echo "Preparing symlink for $pkg → $dest"
  backup_if_conflict "$dest"
  ln -sfv "$src" "$dest"
done

echo "Symlink setup complete."
