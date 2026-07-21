#!/usr/bin/env bash
# Installs Nerd Fonts used across the dotfiles (Ghostty, waybar, sketchybar, dunst, fuzzel, wlogout, wezterm).
# Idempotent: safe to re-run; skips casks already installed via Homebrew or manually in ~/Library/Fonts.

set -uo pipefail   # NOTE: no -e — we want to keep going past individual failures.

# Fonts referenced across the dotfiles:
#   JetBrainsMono Nerd Font   — ghostty, dunst, fuzzel, waybar
#   FiraCode Nerd Font        — wezterm primary
#   Monaspace Radon/Krypton NF — wezterm italic / bold-italic
#   Hack Nerd Font            — sketchybar
#   Ubuntu Mono               — wlogout (only needed on Ubuntu)

# Detect a Nerd Font already installed manually in ~/Library/Fonts so we
# don't fight Homebrew over files the user placed there themselves.
has_manual_font() {
  local family="$1"
  shopt -s nullglob nocaseglob
  local matches=( ~/Library/Fonts/${family}*.ttf ~/Library/Fonts/${family}*.otf )
  shopt -u nocaseglob
  [[ ${#matches[@]} -gt 0 ]]
}

install_cask() {
  local cask="$1"
  local family="${cask#font-}"   # font-jetbrains-mono-nerd-font -> jetbrains-mono-nerd-font

  if brew list --cask "$cask" >/dev/null 2>&1; then
    echo "  ✓ $cask (already installed via Homebrew)"
    return 0
  fi

  if has_manual_font "$family"; then
    echo "  ✓ $cask (manually installed in ~/Library/Fonts — skipping)"
    return 0
  fi

  echo "  → Installing $cask..."
  if brew install --cask "$cask" 2>&1 | tail -3; then
    echo "  ✓ $cask installed"
  else
    echo "  ✗ $cask failed (continuing)" >&2
    return 0   # don't fail the whole script
  fi
}

if [[ "$(uname -s)" == "Darwin" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required on macOS. Install from https://brew.sh first." >&2
    exit 1
  fi

  echo "Installing Nerd Fonts via Homebrew (skipping any already present)..."
  install_cask font-jetbrains-mono-nerd-font
  install_cask font-fira-code-nerd-font
  install_cask font-hack-nerd-font
  install_cask font-monaspace   # may not exist as a cask; helper will report

  echo
  echo "Done. Restart Ghostty to pick up the new fonts."
  echo "Verify with:  fc-list | grep -i 'nerd font'"
else
  echo "Non-macOS detected. Install Nerd Fonts manually:"
  echo "  Ubuntu/Debian:  sudo apt install fonts-jetbrains-mono"
  echo "                  then grab Nerd Font patches from https://www.nerdfonts.com/"
  echo "  Arch:           yay -S nerd-fonts-jetbrains-mono nerd-fonts-fira-code nerd-fonts-hack"
  exit 0
fi
