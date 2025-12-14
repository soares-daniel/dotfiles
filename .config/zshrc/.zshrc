# Path to your oh-my-zsh installation.
# Reevaluate the prompt string each time it's displaying a prompt
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit
source <(kubectl completion zsh)
complete -C '/usr/local/bin/aws_completer' aws

# You may need to manually set your language environment
export LANG=en_US.UTF-8

export EDITOR=/opt/homebrew/bin/nvim

alias la=tree
alias cat=bat

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# GO
export GOPATH='/Users/sedam/go'

# VIM
alias v="/opt/homebrew/bin/nvim"

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/sedam/.vimpkg/bin:${GOPATH}/bin:/Users/sedam/.cargo/bin

alias cl='clear'

# HTTP requests with xh!
alias http="xh"

# VI Mode!!!
bindkey jj vi-cmd-mode

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

### FZF ###
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=/opt/homebrew/bin:$PATH
export PATH=/Users/sedam/.local/bin:$PATH

# navigation
cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }

export XDG_CONFIG_HOME="/Users/sedam/.config"
. "$HOME/.atuin/bin/env"

eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval "$(direnv hook zsh)"

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

stowdotfiles() {
  local repo=~/Code/dotfiles
  echo "📦 Stowing dotfiles from $repo"
  (
    cd "$repo" || return
    stow .
  )
}

# Java
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Python
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"


# Load Angular CLI autocompletion.
source <(ng completion script)

# Add JBang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"


export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"


export AOC_SESSION=53616c7465645f5f876b94b69049f2f8bf54dff99b5f67648635a7784b42a352396c9b43e7316ecf4a6d27fc5b9c5aaf93898372361d85be557d41051203ece0

# bun completions
[ -s "/Users/sedam/.bun/_bun" ] && source "/Users/sedam/.bun/_bun"

# Added by Antigravity
export PATH="/Users/sedam/.antigravity/antigravity/bin:$PATH"
