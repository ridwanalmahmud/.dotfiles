#!/usr/bin/env bash

fzf_parent_dir() {
    local selected="$1"
    local full_path

    local current_dir="${PWD:-$curr_dir}"

    full_path="$(dirname "$current_dir")"

    if [[ -d "$full_path" ]]; then
        echo "$full_path"
    else
        err "Not a directory: $selected"
        echo "$current_dir"
    fi
}

fzf_child_dir() {
    local selected="$1"
    local full_path

    local current_dir="${PWD:-$curr_dir}"

    if [[ "$selected" == /* ]]; then
        full_path="$selected"
    else
        full_path="$current_dir/$selected"
    fi

    if [[ -d "$full_path" ]]; then
        echo "$full_path"
    else
        err "Not a directory: $selected"
        echo "$current_dir"
    fi
}

export -f fzf_child_dir fzf_parent_dir
