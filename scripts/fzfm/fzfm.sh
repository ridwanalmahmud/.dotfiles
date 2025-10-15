#!/usr/bin/env bash

curr_dir="${1:-$HOME/loom}"
if [[ ! -d "$curr_dir" ]]; then
    return 1
fi

err() {
    echo -e "$1" >&2
    sleep 0.5
}

fzf_preview() {
    local selected="$1"
    local full_path

    local current_dir="${PWD:-$curr_dir}"

    if [[ "$selected" == /* ]]; then
        full_path="$selected"
    else
        full_path="$current_dir/$selected"
    fi

    if [[ -d "$full_path" ]]; then
        ls "$full_path" --color -Av --group-directories-first
    elif [[ -f "$full_path" ]]; then
        bat --style=numbers --theme=gruvbox-dark --color=always "$full_path"
    fi
}

export -f err fzf_preview
source $DOTFILES/scripts/fzfm/utils.sh
source $DOTFILES/scripts/fzfm/motion.sh

while true; do
    find_cmd="ls '$curr_dir' -Av --group-directories-first --color"

    bind_keys="ctrl-i:execute(bash -c 'fzf_touch {+}')+reload($find_cmd)"
    bind_keys+=",ctrl-o:execute(bash -c 'fzf_mkdir {+}')+reload($find_cmd)"
    bind_keys+=",ctrl-y:execute(bash -c 'fzf_copy {+}')+reload($find_cmd)"
    bind_keys+=",ctrl-v:execute(bash -c 'fzf_move {+}')+reload($find_cmd)"
    bind_keys+=",ctrl-d:execute(bash -c 'fzf_remove {+}')+reload($find_cmd)"
    bind_keys+=",ctrl-x:execute(bash -c 'fzf_chmod {+}')+reload($find_cmd)"
    bind_keys+=",ctrl-t:execute(bash -c 'fzf_create_project {+}')+reload($find_cmd)"
    bind_keys+=",ctrl-l:execute(bash -c 'new_dir=\$(fzf_child_dir {}); echo \"\$new_dir\" > /tmp/fzf_new_dir')+abort"
    bind_keys+=",ctrl-h:execute(bash -c 'new_dir=\$(fzf_parent_dir {}); echo \"\$new_dir\" > /tmp/fzf_new_dir')+abort"
    bind_keys+=",focus:transform-header:echo $curr_dir"

    fzf_opts="--multi --height=70% --layout=reverse --style full --ansi --preview-window right:65%"

    # tmp file to track directory changes
    temp_dir_file="/tmp/fzf_new_dir_$$"
    rm -f "$temp_dir_file"

    cd "$curr_dir"
    selected=$(eval "$find_cmd" | fzf $fzf_opts --preview="bash -c 'fzf_preview {}'" --bind "$bind_keys" --header-label ' CWD ')

    # create the temp file
    if [[ -f "/tmp/fzf_new_dir" ]]; then
        new_dir=$(cat /tmp/fzf_new_dir)
        rm -f /tmp/fzf_new_dir
        echo "$new_dir" >"$temp_dir_file"
    elif [[ -n "$selected" ]]; then
        echo "$selected" | while IFS= read -r line; do
            echo "$curr_dir/$line"
        done | xargs
    fi

    # check if we need to change directory
    if [[ -f "$temp_dir_file" ]]; then
        new_dir=$(cat "$temp_dir_file")
        rm -f "$temp_dir_file"
        if [[ -d "$new_dir" && "$new_dir" != "$curr_dir" ]]; then
            curr_dir="$new_dir"
            continue
        fi
    fi

    break
done
