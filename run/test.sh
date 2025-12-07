#!/usr/bin/env bash
set -euo pipefail

# Adopt existing ~/.config/<name> symlinks that point into repo/.config/<name>
REPO="$HOME/code/dotfiles"
for d in "$REPO/.config"/*; do
  name="$(basename "$d")"
  src="$HOME/.config/$name"
  target="$REPO/.config/$name"
  [[ -e "$d" ]] || continue
  if [[ -L "$src" ]]; then
    resolved="$(readlink -f "$src")" || true
    if [[ "$resolved" == "$(readlink -f "$target")" ]]; then
      echo "OK: $src already symlinks to $target"
      continue
    else
      echo "Adjust: $src symlink points elsewhere; backing up and replacing"
      mv -v "$src" "${src}.pre-stow.bak.$(date +%Y%m%d_%H%M%S)"
      ln -s "$target" "$src"
    fi
  elif [[ -e "$src" ]]; then
    echo "Found real dir/file at $src; will let stow handle (it will back up)."
  fi
done

echo "Adoption pass done."
