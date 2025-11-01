#!/usr/bin/env bash

remote_url=$(git remote get-url origin 2>/dev/null)

if [ -z "$remote_url" ]; then
    echo "Error: No remote 'origin' found or not in a git repository"
    exit 1
fi

convert_to_https() {
    local url="$1"

    # git@github.com:username/repo.git
    if [[ "$url" =~ ^git@github.com:([^/]+)/([^/]+)\.git$ ]]; then
        echo "https://github.com/${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"

    # git@github.com:username/repo
    elif [[ "$url" =~ ^git@github.com:([^/]+)/([^/]+)$ ]]; then
        echo "https://github.com/${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"

    # https://github.com/username/repo.git
    elif [[ "$url" =~ ^https://github.com/([^/]+)/([^/]+)\.git$ ]]; then
        echo "https://github.com/${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"

    # https://github.com/username/repo
    elif [[ "$url" =~ ^https://github.com/([^/]+)/([^/]+)$ ]]; then
        echo "$url"

    # github:username/repo
    elif [[ "$url" =~ ^github:([^/]+)/([^/]+)$ ]]; then
        echo "https://github.com/${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"

    else
        echo "Error: Unsupported URL format: $url"
        return 1
    fi
}

browser_url=$(convert_to_https "$remote_url")

if [ $? -eq 0 ]; then
    echo "Opening $browser_url in browser"
    xdg-open "$browser_url"
else
    echo "$browser_url"
    exit 1
fi
