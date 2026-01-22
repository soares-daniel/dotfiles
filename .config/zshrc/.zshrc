#!/bin/zsh
# ~/.zshrc: Main loader with auto-detection

# Basic zsh setup
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

# Auto-detect context
DOTFILES_CONTEXT="personal"
[[ -d "$HOME/softdev" ]] && DOTFILES_CONTEXT="work"
[[ -n "${DOTFILES_CONTEXT_OVERRIDE:-}" ]] && DOTFILES_CONTEXT="$DOTFILES_CONTEXT_OVERRIDE"

# Source common base
[[ -f "$HOME/.config/zshrc/.zshrc.common" ]] && source "$HOME/.config/zshrc/.zshrc.common"

# Source context-specific config
[[ -f "$HOME/.config/zshrc/.zshrc.$DOTFILES_CONTEXT" ]] && source "$HOME/.config/zshrc/.zshrc.$DOTFILES_CONTEXT"

# Source local overrides (never tracked)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Dev Tools CLI
export PATH="$PATH:/home/d-a-soares/.local/bin"
