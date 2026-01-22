#!/bin/bash
# ~/.bashrc: Main loader with auto-detection

# Auto-detect context
DOTFILES_CONTEXT="personal"
[[ -d "$HOME/softdev" ]] && DOTFILES_CONTEXT="work"
[[ -n "${DOTFILES_CONTEXT_OVERRIDE:-}" ]] && DOTFILES_CONTEXT="$DOTFILES_CONTEXT_OVERRIDE"

# Source common base
[[ -f "$HOME/.config/bashrc/.bashrc.common" ]] && source "$HOME/.config/bashrc/.bashrc.common"

# Source context-specific config
[[ -f "$HOME/.config/bashrc/.bashrc.$DOTFILES_CONTEXT" ]] && source "$HOME/.config/bashrc/.bashrc.$DOTFILES_CONTEXT"

# Source local overrides (never tracked)
[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local

# Dev Tools CLI
export PATH="$PATH:/home/d-a-soares/.local/bin"

# Load Angular CLI autocompletion.
source <(ng completion script)

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
