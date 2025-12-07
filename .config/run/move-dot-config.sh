#!/usr/bin/env bash
set -euo pipefail

# Move selected ~/.config/<dir> into ~/code/dotfiles/.config/<dir>
# Then replace original with a symlink.
#
# Features:
# - Multiple args or interactive picker (fzf) if no args
# - Dry-run (-n) shows what would happen
# - Skip existing/identical targets
# - Backup existing non-empty targets/sources
# - Rollback on partial failure
#
# Usage:
#   move-dot-config.sh [-n] <dir1> <dir2> ...
#   move-dot-config.sh            # interactive (fzf)
#
# Requirements (interactive mode):
#   - fzf (optional)

DRY_RUN=0
if [[ "${1:-}" == "-n" || "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=1
  shift || true
fi

SRC_ROOT="${HOME}/.config"
DST_ROOT="${HOME}/code/dotfiles/.config"
BACKUP_ROOT="${HOME}/code/dotfiles/.backup.$(date +%Y%m%d_%H%M%S)"

log() { printf '[*] %s\n' "$*"; }
warn() { printf '[!] %s\n' "$*" >&2; }
die() { printf '[x] %s\n' "$*" >&2; exit 1; }

ensure_dirs() {
  [[ $DRY_RUN -eq 1 ]] && return 0
  mkdir -p "$DST_ROOT"
  mkdir -p "$BACKUP_ROOT"
}

# Collect selection
SELECTION=("$@")
if [[ ${#SELECTION[@]} -eq 0 ]]; then
  if command -v fzf >/dev/null 2>&1; then
    log "No args provided. Launching fzf to pick directories from $SRC_ROOT (multi-select with Tab)"
    mapfile -t SELECTION < <(find "$SRC_ROOT" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | fzf -m)
  else
    die "No directories specified and fzf not found. Pass directory names (e.g., 'wezterm waybar')."
  fi
fi

[[ ${#SELECTION[@]} -gt 0 ]] || die "Nothing selected."

log "Source root: $SRC_ROOT"
log "Dest root:   $DST_ROOT"
log "Backup root: $BACKUP_ROOT"
[[ $DRY_RUN -eq 1 ]] && log "(dry-run mode)"

ensure_dirs

# Keep track for rollback
ROLLED_MOVES=()
ROLLED_LINKS=()
ROLLED_BACKUPS=()

rollback() {
  warn "Rolling back due to error..."
  # Remove created symlinks
  for link in "${ROLLED_LINKS[@]}"; do
    [[ -L "$link" ]] || continue
    log "Rollback: removing symlink $link"
    [[ $DRY_RUN -eq 1 ]] || rm -f "$link"
  done
  # Move dirs back
  for move_spec in "${ROLLED_MOVES[@]}"; do
    IFS=$'\t' read -r dst src <<<"$move_spec"
    [[ -d "$dst" ]] || continue
    log "Rollback: moving back $dst -> $src"
    [[ $DRY_RUN -eq 1 ]] || mv "$dst" "$src"
  done
  # Restore backups
  for bak_spec in "${ROLLED_BACKUPS[@]}"; do
    IFS=$'\t' read -r bak orig <<<"$bak_spec"
    [[ -e "$bak" ]] || continue
    log "Rollback: restoring backup $bak -> $orig"
    [[ $DRY_RUN -eq 1 ]] || mv "$bak" "$orig"
  done
}

trap 'rc=$?; if [[ $rc -ne 0 ]]; then rollback; fi; exit $rc' EXIT

for name in "${SELECTION[@]}"; do
  SRC="$SRC_ROOT/$name"
  DST="$DST_ROOT/$name"
  LINK="$SRC"

  # Validate source
  if [[ ! -d "$SRC" && ! -L "$SRC" ]]; then
    warn "Skipping '$name': $SRC not found."
    continue
  fi

  # If source is already a symlink pointing to DST, skip
  if [[ -L "$SRC" ]]; then
    target="$(readlink -f "$SRC")" || target=""
    if [[ "$target" == "$(readlink -f "$DST_ROOT")/$name" ]]; then
      log "Skipping '$name': already symlinked to dotfiles."
      continue
    fi
  fi

  # If destination exists and differs, back it up or skip
  if [[ -e "$DST" ]]; then
    # If dst exists and is identical content (naive check: rsync dry-run), we can remove src and symlink.
    if command -v rsync >/dev/null 2>&1; then
      if rsync -a --dry-run --delete "$SRC/" "$DST/" | grep -qvE 'sending incremental file list|sent [0-9]|total size is'; then
        log "Destination differs for '$name'; creating backup."
        BAK="$BACKUP_ROOT/${name}.dst"
        log "Backup $DST -> $BAK"
        if [[ $DRY_RUN -eq 0 ]]; then
          mkdir -p "$(dirname "$BAK")"
          mv "$DST" "$BAK"
        fi
        ROLLED_BACKUPS+=("$BAK"$'\t'"$DST")
      else
        log "Destination '$DST' already matches content (rsync check)."
      fi
    else
      # Fallback: if it exists, back it up to be safe
      log "Destination '$DST' exists; no rsync available. Backing up."
      BAK="$BACKUP_ROOT/${name}.dst"
      if [[ $DRY_RUN -eq 0 ]]; then
        mkdir -p "$(dirname "$BAK")"
        mv "$DST" "$BAK"
      fi
      ROLLED_BACKUPS+=("$BAK"$'\t'"$DST")
    fi
  fi

  # If source exists and is not a symlink, move it into dotfiles
  if [[ -d "$SRC" && ! -L "$SRC" ]]; then
    log "Moving '$SRC' -> '$DST'"
    if [[ $DRY_RUN -eq 0 ]]; then
      mkdir -p "$(dirname "$DST")"
      mv "$SRC" "$DST"
    fi
    ROLLED_MOVES+=("$DST"$'\t'"$SRC")
  elif [[ -L "$SRC" ]]; then
    # If it's a symlink but not to DST, back it up
    log "Source '$SRC' is a symlink; backing up original link."
    BAK="$BACKUP_ROOT/${name}.src.link"
    if [[ $DRY_RUN -eq 0 ]]; then
      mkdir -p "$(dirname "$BAK")"
      mv "$SRC" "$BAK"
    fi
    ROLLED_BACKUPS+=("$BAK"$'\t'"$SRC")
  fi

  # Ensure destination exists now
  if [[ ! -d "$DST" ]]; then
    warn "Destination missing after move for '$name'; creating empty dir."
    [[ $DRY_RUN -eq 1 ]] || mkdir -p "$DST"
  fi

  # Create symlink at original path
  log "Symlink '$LINK' -> '$DST'"
  if [[ $DRY_RUN -eq 0 ]]; then
    ln -sfn "$DST" "$LINK"
  fi
  ROLLED_LINKS+=("$LINK")

  log "Done: $name"
done

trap - EXIT
log "All done."
if [[ $DRY_RUN -eq 1 ]]; then
  log "(dry-run only; nothing changed)"
fi
