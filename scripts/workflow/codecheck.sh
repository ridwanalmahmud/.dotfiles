#!/usr/bin/env bash

set -e

SEARCH_DIR="${1:-$(git rev-parse --show-toplevel 2>/dev/null || echo .)}"

count_patterns() {
    local pattern=$1
    rg --ignore-file="$DOTFILES/scripts/workflow/devutils/.checkignore" -c "$pattern" "$SEARCH_DIR" 2>/dev/null |
        awk -F: '{sum += $2} END {print sum+0}'
}

TODO_COUNT=$(count_patterns "TODO:")
FIXME_COUNT=$(count_patterns "FIXME:")
DEBUG_COUNT=$(count_patterns "DEBUG:")
TOTAL_COUNT=$((TODO_COUNT + FIXME_COUNT + DEBUG_COUNT))

check_comments() {
    rg --ignore-file="$DOTFILES/scripts/workflow/devutils/.checkignore" -n "$1" "$SEARCH_DIR" |
        awk -v pattern="$1" -v count="$2" '{print $0 " | " pattern " [" count " total]"}'
}

search_comments() {
    check_comments "TODO:" "$TODO_COUNT"
    check_comments "FIXME:" "$FIXME_COUNT"
    check_comments "DEBUG:" "$DEBUG_COUNT"
}

open_all_files() {
    local all_files=$(rg --ignore-file="$DOTFILES/scripts/workflow/devutils/.checkignore" -l -e "TODO:" -e "FIXME:" -e "DEBUG:" "$SEARCH_DIR")
    [[ -z "$all_files" ]] && echo "No files with TODOs, FIXMEs, or DEBUGs found!" && exit 0

    local nvim_args=""
    while IFS= read -r file; do
        local first_line=$(rg --ignore-file="$DOTFILES/scripts/workflow/devutils/.checkignore" -n -e "TODO:" -e "FIXME:" -e "DEBUG:" "$file" | head -1 | cut -d: -f1)
        [[ -n "$first_line" ]] && nvim_args+=" +$first_line $file " && echo "File: $file (first comment at line $first_line)"
    done <<<"$(echo "$all_files" | sort -u)"

    echo "Opening $(echo "$all_files" | sort -u | wc -l) files with comments"
    nvim $nvim_args
}

[[ "$1" == "-a" ]] && SEARCH_DIR="${2:-$(git rev-parse --show-toplevel 2>/dev/null || echo .)}" && open_all_files && exit 0

results=$(search_comments)
[[ -z "$results" ]] && echo -e "No TODOs, FIXMEs, or DEBUGs found!" && exit 0

unique_files_list=$(echo "$results" | awk -F: '{
    file = $1
    count[file]++
}
END {
    for (file in count) {
        cmd = "rg --ignore-file=\"$DOTFILES/scripts/workflow/devutils/.checkignore\" -n -e \"TODO:\" -e \"FIXME:\" -e \"DEBUG:\" \"" file "\" | head -1 | cut -d: -f1"
        cmd | getline first_line
        close(cmd)
        print file " | " count[file] " comment(s) | first:" first_line
    }
}' | sort)

selected=$(echo "$unique_files_list" | fzf --multi --preview-window=right:65% \
    --header="TODOs: $TODO_COUNT | FIXMEs: $FIXME_COUNT | DEBUGs: $DEBUG_COUNT | Total: $TOTAL_COUNT" \
    --preview='file=$(echo {} | cut -d"|" -f1 | sed '\''s/ $//'\'')
        [[ -n "$file" ]] && {
            echo "=== File Summary ==="
            rg --ignore-file="$DOTFILES/scripts/workflow/devutils/.checkignore" -n -e "TODO:" -e "FIXME:" -e "DEBUG:" "$file"
            echo
            bat --theme=gruvbox-dark --style="numbers,header" --color=always "$file" 2>/dev/null || echo "Unable to preview file"
        } || echo "Invalid selection"
    ')

[[ -z "$selected" ]] && exit 0

nvim_args=""
while IFS= read -r line; do
    file=$(echo "$line" | cut -d"|" -f1 | sed 's/ $//')
    first_line=$(echo "$line" | grep -o 'first:[0-9]*' | cut -d: -f2)

    if [[ -z "$first_line" ]]; then
        first_line=$(rg --ignore-file="$DOTFILES/scripts/workflow/devutils/.checkignore" -n -e "TODO:" -e "FIXME:" -e "DEBUG:" "$file" | head -1 | cut -d: -f1)
    fi

    [[ -n "$first_line" ]] && nvim_args+=" +$first_line $file " && echo "File: $file (first comment at line $first_line)" || nvim_args+=" $file "
done <<<"$selected"

echo "Opening $(echo "$selected" | wc -l) files with comments"
nvim $nvim_args
