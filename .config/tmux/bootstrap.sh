#!/bin/bash
# ~/.config/tmux/bootstrap.sh
# Context-aware tmux bootstrap.
# - Work machine: creates and attaches the 'dev' session for the SSA portal project.
# - Personal machine: no default workspace; user creates sessions manually.
#
# Ghostty launches us via `/usr/bin/login -flp ... --noprofile --norc`, which
# strips the user environment (no .zshrc, no /etc/profile). That leaves PATH
# as just /usr/bin:/bin — so /opt/homebrew/bin/tmux and friends are invisible.
# We add the common Homebrew paths back here so the rest of the script works.

for p in /opt/homebrew/bin /usr/local/bin /home/linuxbrew/.linuxbrew/bin; do
  [[ -d "$p" ]] && [[ ":$PATH:" != *":$p:"* ]] && export PATH="$p:$PATH"
done

DOTFILES_CONTEXT="personal"
[[ -d "$HOME/softdev" ]] && DOTFILES_CONTEXT="work"
[[ -n "${DOTFILES_CONTEXT_OVERRIDE:-}" ]] && DOTFILES_CONTEXT="$DOTFILES_CONTEXT_OVERRIDE"

if [[ "$DOTFILES_CONTEXT" == "work" ]]; then
  DEV_DIR="$HOME/softdev/code/ics2-ssa-portal-container"

  if ! tmux has-session -t dev 2>/dev/null; then
    tmux new-session -d -s dev -n main -c "$DEV_DIR"
    tmux split-window -h -t dev:main -c "$DEV_DIR"
    tmux split-window -v -t dev:main.2 -c "$DEV_DIR"
    tmux select-layout -t dev:main main-vertical
    tmux resize-pane -t dev:main.1 -x 50%
  fi

  exec tmux attach -t dev
else
  # Personal machine: no default workspace, just start a fresh tmux server.
  exec tmux new-session
fi
