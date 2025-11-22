# ~/.bashrc: executed by bash(1) for non-login shells.

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
export PATH=$PATH:"$HOME/.cargo/bin"

export AWS_REGION=eu-west-1
export AWS_PROFILE=softdev-admin
export XDG_CONFIG_HOME="$HOME/.config"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$HOME/.local/bin:$PATH

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Safe source helper
try_source() {
  local name="$1" file="$2"
  if [ -f "$file" ]; then
    source "$file"
  else
    echo "[WARN] Optional component not found: $name ($file)"
  fi
}

# Safe command check
require_cmd() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "[ERROR] Required command '$cmd' not found in PATH."
  }
}

check_optional() {
  # Usage: check_optional <command> [command_to_run_if_found] [label]
  # Example: check_optional starship 'eval "$(starship init bash)"' "Starship prompt"

  local cmd="$1"
  local action="$2"
  local label="${3:-$cmd}"

  if command -v "$cmd" >/dev/null 2>&1; then
    if [ -n "$action" ]; then
      eval "$action"
    fi
  else
    echo "[WARN] Optional component not found: ${label}"
  fi
}

# Criticals
require_cmd sdk
require_cmd aws
require_cmd mvn
require_cmd docker
require_cmd nvm
require_cmd kubectl

# Optionals
check_optional fzf "" "fzf"
check_optional ng 'source <(ng completion script)' "Angular CLI"
check_optional starship 'eval "$(starship init bash)"' "Starship prompt"
check_optional eza "" "eza"

# ---- Java / Maven Utilities ----

# List installed JDKs
alias listjava='ls -1 ~/.sdkman/candidates/java'

# Helper: switch java and show version
usejava() {
  # Usage: usejava <partial_or_full_version>
  local ver_match
  ver_match=$(ls ~/.sdkman/candidates/java | grep -m1 "$1")
  if [ -z "$ver_match" ]; then
    echo "No matching Java version found for: $1"
    return 1
  fi
  echo "Switching to Java version: $ver_match"
  sdk use java "$ver_match" >/dev/null
  java -version 2>&1 | head -n 2
}

# Maven with specific Java version (temporal)
mvnwith() {
  # Usage: mvnwith <version_part> [mvn args...]
  # Example: mvnwith 17 clean package
  local tmp_java previous_java
  tmp_java=$(ls ~/.sdkman/candidates/java | grep -E -m1 "^$1(\.|$)")
  if [ -z "$tmp_java" ]; then
    echo "No matching Java version found for: $1"
    return 1
  fi

  previous_java=$(readlink ~/.sdkman/candidates/java/current)
  echo "Temporarily using Java $tmp_java"
  sdk use java "$tmp_java" >/dev/null
  java -version 2>&1 | head -n 1

  shift
  mvn "$@"

  # Restore previous Java after command
  if [ -n "$previous_java" ]; then
    sdk use java "$previous_java" >/dev/null
    echo "Restored Java to $previous_java"
  fi
}

# Common shortcuts
alias mci='mvn clean install'
alias mciskip='mvn clean install -DskipTests'

# Convenience aliases for quick Java targets
alias mci8='mvnwith 8 clean install'
alias mci11='mvnwith 11 clean install'
alias mci17='mvnwith 17 clean install'
alias mciskip8='mvnwith 8 clean install -DskipTests'
alias mciskip11='mvnwith 11 clean install -DskipTests'
alias mciskip17='mvnwith 17 clean install -DskipTests'

# ---- Project Navigation ----
projroot=~/softdev/code

cddf() { cd "$projroot/ics2-ssa-data-factory" || return; }
cdportal() {
  local script="$projroot/ics2-ssa-portal/ics2-ssa-dev-utils/ics2-ssa-installation-scripts.sh"
  if [ -f "$script" ]; then
    ( cd "$(dirname "$script")" && source "$(basename "$script")" )
    cd "$projroot/ics2-ssa-portal" || return
  else
    echo "Script not found: $script"
  fi
}
gossaproject() { cd "$projroot/ics2-ssa-portal" || return; }

cdansible() { cd "$projroot/ansible-common" || return; }
ansiblenv() { cdansible && cd ./VMs/env-docker || return; }
ansiblestart() { ansiblenv && git pull && ./10_env.sh start; }
ansiblestop() { ansiblenv && ./10_env.sh stop; }

cddatalabdesign() { cd "$projroot/ics2-ssa-data-lab-design" || return; }
cddatalabtools() { cd "$projroot/ics2-ssa-data-lab-tools" || return; }

# ---- AWS EKS / k9s Helpers ----
eksuse() {
  # Usage: eksuse <env>
  # Example: eksuse dev3
  local cluster="d-ew1-ics2-ssa-ssa-$1-eks"
  aws eks update-kubeconfig \
    --region eu-west-1 \
    --name "$cluster" \
    --profile softdev-admin &&
    echo "Switched kubeconfig to: $cluster"
}
alias k9s-dev1='eksuse ssa-dev1'
alias k9s-dev2='eksuse ssa-dev2'
alias k9s-dev3='eksuse ssa-dev3'
alias k9s-dev4='eksuse ssa-dev4'
alias k9s-dev5='eksuse ssa-dev5'
alias k9s-devops='eksuse ssa-devops'
alias k9s-arch='eksuse ssa-arch'
alias k9s-prod='eksuse ssa-prod'
alias k9s-pgs1='eksuse ssa-pgs1'
alias k9s-int='eksuse ics2-int'
# Quickly see which cluster is active
alias kctx='kubectl config current-context'
# Check current AWS profile and region
alias awswhoami='aws sts get-caller-identity && aws configure list'
# Easy MFA refresh
alias mfa='~/.aws/mfa.sh'

alias ls="eza --color=always --group-directories-first --icons"
alias ll="eza -la --icons --octal-permissions --group-directories-first"
alias l="eza -bGF --header --git --color=always --group-directories-first --icons"
alias llm="eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons"
alias la="eza --long --all --group --group-directories-first"
alias lx="eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons"
alias lS="eza -1 --color=always --group-directories-first --icons"
alias lt="eza --tree --level=2 --color=always --group-directories-first --icons"
alias l.="eza -a | grep -E '^\.'"

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

alias preview="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias cpreview="preview | xargs zed"

alias cl='clear'
alias reload='source ~/.bashrc && echo "🔁 bashrc reloaded"'

# ---- Dotfiles helpers ----
alias cddotfiles="cd ~/code/dotfiles"
stowdotfiles() {
  local repo=~/code/dotfiles
  echo "📦 Stowing dotfiles from $repo"
  (
    cd "$repo" || return
    stow .
  )
}
