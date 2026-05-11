#!/bin/bash
# Called by tmux hooks to update pane count for the current window
PANE_COUNT=$(tmux list-panes -t "$1" 2>/dev/null | wc -l | tr -d ' ')
tmux set -t "$1" @pane_count "[$PANE_COUNT]"
