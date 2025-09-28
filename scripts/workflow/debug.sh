#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <binary>"
    exit 1
fi

BINARY="$1"
SESSION_NAME="(Debug)$(basename "$BINARY")"

if [[ ! -f "$BINARY" ]]; then
    echo "Error: Binary '$BINARY' not found"
    exit 1
fi

tmux kill-session -t "$SESSION_NAME" 2>/dev/null

windows=("pwndbg" "disasm" "memory" "python")

tmux new-session -d -s "$SESSION_NAME" -n "${windows[0]}" "pwndbg -q ./$BINARY"

tmux new-window -t "$SESSION_NAME" -n "${windows[1]}" -d "cat -"
tmux split-window -t "$SESSION_NAME:${windows[1]}" -h -d "cat -"
tmux split-window -t "$SESSION_NAME:${windows[1]}.1" -v -d "cat -"

tmux new-window -t "$SESSION_NAME" -n "${windows[2]}" -d "cat -"
tmux split-window -t "$SESSION_NAME:${windows[2]}" -h -d "cat -"
tmux split-window -t "$SESSION_NAME:${windows[2]}" -v -d "cat -"
tmux split-window -t "$SESSION_NAME:${windows[2]}.2" -v -d "cat -"

tmux new-window -t "$SESSION_NAME" -n "${windows[3]}"
tmux split-window -t "$SESSION_NAME:${windows[3]}" -v -d

get_tty() {
    tmux display-message -p -t "$SESSION_NAME:$1" '#{pane_tty}' 2>/dev/null || echo ""
}

ttys=(
    "$(get_tty "${windows[1]}.0")"
    "$(get_tty "${windows[1]}.1")"
    "$(get_tty "${windows[1]}.2")"
    "$(get_tty "${windows[2]}.0")"
    "$(get_tty "${windows[2]}.1")"
    "$(get_tty "${windows[2]}.2")"
    "$(get_tty "${windows[2]}.3")"
)

for i in "${!ttys[@]}"; do
    case $i in
    0) context="disasm" ;;
    1) context="code" ;;
    2) context="expressions" ;;
    3) context="stack" ;;
    4) context="regs" ;;
    5) context="legend" ;;
    6) context="backtrace" ;;
    esac
    tmux send-keys -t "$SESSION_NAME:${windows[0]}" "contextoutput $context ${ttys[i]} true" C-m
done
tmux send-keys -t "$SESSION_NAME:${windows[3]}" "python -quit" C-m "clear" C-m

tmux select-window -t "$SESSION_NAME:${windows[0]}"

if [[ -n $TMUX ]]; then
    tmux switch-client -t "$SESSION_NAME"
else
    tmux attach-session -t "$SESSION_NAME"
fi
