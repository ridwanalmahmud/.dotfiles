#!/usr/bin/env bash

curr_dir="${1:-$HOME/loom}"
if [[ ! -d "$curr_dir" ]]; then
    return 1
fi

err() {
    echo -e "$1"
    sleep 0.5
}

fzf_touch() {
    local selected=$(dirname "$1")
    read -e -p "File Name(s): " file_names
    printf '%s\n' $file_names | xargs -I{} touch "$selected/{}"
}

fzf_mkdir() {
    local selected=$(dirname "$1")
    read -e -p "Dir Name(s): " dir_names
    printf '%s\n' $dir_names | xargs -I{} mkdir -p "$selected/{}"
}

fzf_copy() {
    local selected=()
    for arg in "$@"; do
        selected+=("$arg")
    done
    echo "Copy the following items:"
    printf '  %s\n' "${selected[@]}"
    read -e -p "Dest dir: " -i "$PWD/" dest_dir

    if [[ ! -d "$dest_dir" ]]; then
        echo -e "$dest_dir does not exist."
        read -e -p "Create $dest_dir Dir? (y/n): " prompt
        if [[ "$prompt" =~ ^[Yy]$ ]]; then
            mkdir -p "$dest_dir"
        fi
    fi
    for item in "${selected[@]}"; do
        cp -r "$item" "$dest_dir"
    done
}

fzf_move() {
    local selected=()
    for arg in "$@"; do
        selected+=("$arg")
    done
    echo "Move the following items:"
    printf '  %s\n' "${selected[@]}"
    read -e -p "Dest dir: " -i "$PWD/" dest_dir

    if [[ ! -d "$dest_dir" ]]; then
        echo -e "$dest_dir does not exist."
        read -e -p "Create $dest_dir Dir? (y/n): " prompt
        if [[ "$prompt" =~ ^[Yy]$ ]]; then
            mkdir -p "$dest_dir"
        fi
    fi

    mv "${selected[@]}" "$dest_dir"
}

fzf_remove() {
    local selected=()
    for arg in "$@"; do
        selected+=("$arg")
    done

    echo "The following items will be PERMANENTLY removed:"
    printf '  %s\n' "${selected[@]}"

    read -e -p "Remove all above items? (y/N): " prompt
    if [[ "$prompt" =~ ^[Yy]$ ]]; then
        rm -rf "${selected[@]}" || err "✗ Failed to delete some items"
    else
        err "Deletion cancelled"
    fi
}

fzf_chmod() {
    local selected="$1"
    echo "Permissions: $(stat -c %A "$selected")/$(stat -c %a "$selected")"
    read -e -p "Change Permissions: " -i "+x" perm
    chmod "$perm" "$selected"
}

fzf_create_project() {
    local selected=$(dirname "$1")
    read -e -p "Project Name: " project_name
    read -e -p "Project Type: " -i "c" project_type
    read -e -p "Build Type: " -i "make" build_type
    read -e -p "Lib Support: " -i "never" lib_support

    $DOTFILES/scripts/workflow/createproject.sh -d $selected -N $project_name -t $project_type -B $build_type -L $lib_support
}

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

export -f err fzf_touch fzf_mkdir fzf_copy fzf_move fzf_remove fzf_chmod fzf_child_dir fzf_parent_dir fzf_preview fzf_create_project

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
