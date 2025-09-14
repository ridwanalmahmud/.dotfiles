#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <binary>"
    exit 1
fi

BINARY="$1"
SESSION_NAME="(Debug)$(basename $BINARY)"

if [ ! -f "$BINARY" ]; then
    echo "Error: Binary '$BINARY' not found"
    exit 1
fi

tmux kill-session -t "$SESSION_NAME" 2>/dev/null

win_0="pwndbg"
win_1="disasm"
win_2="memory"
win_3="python"

tmux new-session -d -s "$SESSION_NAME" -n "$win_0" "pwndbg -q ./$BINARY"

tmux new-window -t "$SESSION_NAME" -n "$win_1" -d "cat -"
tmux new-window -t "$SESSION_NAME" -n "$win_2" -d "cat -"
tmux new-window -t "$SESSION_NAME" -n "$win_3"

tty_disasm=$(tmux display-message -p -t "$SESSION_NAME:$win_1" '#{pane_tty}' 2>/dev/null || echo "")
tty_legend=$(tmux display-message -p -t "$SESSION_NAME:$win_2" '#{pane_tty}' 2>/dev/null || echo "")

tmux send-keys -t "$SESSION_NAME:$win_0" "contextoutput disasm $tty_disasm true" C-m
tmux send-keys -t "$SESSION_NAME:$win_0" "contextoutput stack $tty_disasm true" C-m
tmux send-keys -t "$SESSION_NAME:$win_0" "contextoutput legend $tty_legend true" C-m
tmux send-keys -t "$SESSION_NAME:$win_0" "contextoutput backtrace $tty_legend true" C-m
tmux send-keys -t "$SESSION_NAME:$win_0" "contextoutput regs $tty_legend true" C-m
tmux send-keys -t "$SESSION_NAME:$win_3" "python -quit" C-m "clear" C-m

tmux select-window -t "$SESSION_NAME:$win_0"

if [[ -n $TMUX ]]; then
    tmux switch-client -t "$SESSION_NAME"
else
    tmux attach-session -t "$SESSION_NAME"
fi
