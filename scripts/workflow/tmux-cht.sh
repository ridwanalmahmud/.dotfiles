#!/usr/bin/env bash

langs=("assembly" "c" "cpp" "rust" "go" "python" "lua" "bash")
utils=("ripgrep" "find" "sed" "perl" "rsync" "ffmpeg" "nmap" "strace" "ltrace")

all_options=("${langs[@]}" "${utils[@]}")
selected=$(printf "%s\n" "${all_options[@]}" | fzf)

[[ -z "$selected" ]] && exit 1

read -rp "Query ❯ " query

[[ -z "$query" ]] && exit 1

url_encode() {
    if command -v python3 &> /dev/null; then
        python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
    else
        echo "$1" | sed 's/ /+/g'
    fi
}

encoded_query=$(url_encode "$query")

if printf "%s\n" "${langs[@]}" | grep -q "^${selected}$"; then
    url="cht.sh/$selected/$encoded_query"
    bat_lang="$selected"
else
    url="cht.sh/$selected~$encoded_query"
    bat_lang="bash"
fi

bat_opts="-l '$bat_lang' --paging=always --style=numbers --theme=gruvbox-dark --color=always"
tmux neww bash -c "curl -s '$url?T' | bat $bat_opts"
