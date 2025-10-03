#!/usr/bin/env bash

set -e

SEARCH_DIR="${1:-$(git rev-parse --show-toplevel 2>/dev/null || echo .)}"

check_comments() {
    pattern=$1
    rg --ignore-file="$DOTFILES/scripts/workflow/devutils/.checkignore" -n "$pattern" "$SEARCH_DIR" || {
        echo -e "No '$pattern's Found!"
    }
}

search_comments() {
    check_comments "TODO:"
    check_comments "FIXME:"
    check_comments "DEBUG:"
}

results=$(search_comments)

if [[ -z "$results" ]]; then
    echo -e "No TODOs, FIXMEs, or DEBUGs found!"
    exit 0
fi

selected=$(echo "$results" | fzf --multi --style=minimal --preview-window=right:65% --preview='
    file=$(echo {} | cut -d: -f1)
    line=$(echo {} | cut -d: -f2)
    bat --theme=gruvbox-dark --style=numbers --color=always --highlight-line "$line" "$file" 2>/dev/null
')

if [[ -z "$selected" ]]; then
    return
fi

nvim_args=$(echo "$selected" | while IFS= read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    line_num=$(echo "$line" | cut -d: -f2)
    printf "+%s %s " "$line_num" "$file"
done)

nvim $nvim_args
