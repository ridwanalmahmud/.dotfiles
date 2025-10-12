#!/usr/bin/env bash

msg() {
    echo -e "$HOME/$1"
    sleep 0.5
}

fzf_touch() {
    local selected="$HOME/$1"
    if [[ -d "$selected" ]]; then
        read -e -p "File Name(s): " file_names
        printf '%s\n' $file_names | xargs -I{} touch "$selected/{}"
    else
        msg "Not a dir: $selected"
    fi
}

fzf_mkdir() {
    local selected="$HOME/$1"
    if [[ -d "$selected" ]]; then
        read -e -p "Dir Name(s): " dir_names
        printf '%s\n' $dir_names | xargs -I{} mkdir -p "$selected/{}"
    else
        msg "Not a dir: $selected"
    fi
}

fzf_copy() {
    local selected=()
    for arg in "$@"; do
        selected+=("$HOME/$arg")
    done
    echo "Copy the following items:"
    printf '  %s\n' "${selected[@]}"
    read -e -p "Dest dir: " -i "${selected[0]}" dest_dir

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
        selected+=("$HOME/$arg")
    done
    echo "Move the following items:"
    printf '  %s\n' "${selected[@]}"
    read -e -p "Dest dir: " -i "${selected[0]}" dest_dir

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
        selected+=("$HOME/$arg")
    done

    echo "The following items will be PERMANENTLY removed:"
    printf '  %s\n' "${selected[@]}"

    read -e -p "Remove all above items? (y/N): " prompt
    if [[ "$prompt" =~ ^[Yy]$ ]]; then
        rm -rf "${selected[@]}" || msg "✗ Failed to delete some items"
    else
        msg "Deletion cancelled"
    fi
}

fzf_preview() {
    local selected="$HOME/$1"
    if [[ -d "$selected" ]]; then
        ls "$selected" --color -Av --group-directories-first
    elif [[ -f "$selected" ]]; then
        bat --style=numbers --theme=gruvbox-dark --color=always "$selected"
    fi
}

export -f msg fzf_touch fzf_mkdir fzf_copy fzf_move fzf_remove fzf_preview

search_dir="${1:-$HOME/loom}"
if [[ ! -d "$search_dir" ]]; then
    return 1
fi

find_cmd="find '$search_dir' \\( -type f -o -type d \\) -not -path '*git*' | sed 's|^$HOME/||'"

bind_keys="ctrl-a:execute(bash -c 'fzf_touch {+}')+reload($find_cmd)"
bind_keys+=",ctrl-o:execute(bash -c 'fzf_mkdir {+}')+reload($find_cmd)"
bind_keys+=",ctrl-y:execute(bash -c 'fzf_copy {+}')+reload($find_cmd)"
bind_keys+=",ctrl-v:execute(bash -c 'fzf_move {+}')+reload($find_cmd)"
bind_keys+=",ctrl-x:execute(bash -c 'fzf_remove {+}')+reload($find_cmd)"
fzf_opts="--multi --style minimal --preview-window right:65%"

selected=$(eval "$find_cmd" | fzf $fzf_opts --preview="bash -c 'fzf_preview {}'" --bind "$bind_keys")

if [[ -n "$selected" ]]; then
    echo "$selected" | while IFS= read -r line; do
        echo "$HOME/$line"
    done
fi | xargs
