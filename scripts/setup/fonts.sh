#!/usr/bin/env bash

set -e

if [[ $# -eq 0 ]]; then
    $HOME/.dotfiles/fonts/maple_fonts.sh
    $HOME/.dotfiles/fonts/monaspace_fonts.sh
    $HOME/.dotfiles/fonts/nerds_fonts.sh
fi

while [[ $# -gt 0 ]]; do
    case $1 in
    --all)
        $HOME/.dotfiles/fonts/maple_fonts.sh
        $HOME/.dotfiles/fonts/monaspace_fonts.sh
        $HOME/.dotfiles/fonts/nerds_fonts.sh
        shift
        ;;
    --maple)
        $HOME/.dotfiles/fonts/maple_fonts.sh
        shift
        ;;
    --jetbrains)
        $HOME/.dotfiles/fonts/nerds_fonts.sh
        shift
        ;;
    --monaspace)
        $HOME/.dotfiles/fonts/monaspace_fonts.sh
        shift
        ;;
    *)
        echo "Unknown option: $1"
        show_usage
        exit 1
        ;;
    esac
done
