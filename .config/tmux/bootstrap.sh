#!/bin/bash
# ~/.config/tmux/bootstrap.sh
# Creates the predefined 'dev' session if it does not exist.

DEV_DIR="$HOME/softdev/code/ics2-ssa-portal-container"

if ! tmux has-session -t dev 2>/dev/null; then
  tmux new-session -d -s dev -n main -c "$DEV_DIR"
  tmux split-window -h -t dev:main -c "$DEV_DIR"
  tmux split-window -v -t dev:main.2 -c "$DEV_DIR"
  tmux select-layout -t dev:main main-vertical
  tmux resize-pane -t dev:main.1 -x 50%
fi
