#!/usr/bin/env bash

set -e

FONT_PATH=$HOME/.local/share/fonts

jetbrains_dir=$FONT_PATH/nerd_jetbrains

mkdir -p $jetbrains_dir

jetbrains_fonts=(
    "JetBrainsMono/Ligatures/Light/JetBrainsMonoNerdFontMono-Light.ttf"
    "JetBrainsMono/Ligatures/LightItalic/JetBrainsMonoNerdFontMono-LightItalic.ttf"
    "JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFontMono-Regular.ttf"
    "JetBrainsMono/Ligatures/Italic/JetBrainsMonoNerdFontMono-Italic.ttf"
    "JetBrainsMono/Ligatures/SemiBold/JetBrainsMonoNerdFont-SemiBold.ttf"
    "JetBrainsMono/Ligatures/SemiBoldItalic/JetBrainsMonoNerdFont-SemiBoldItalic.ttf"
    "JetBrainsMono/Ligatures/Bold/JetBrainsMonoNerdFontMono-Bold.ttf"
    "JetBrainsMono/Ligatures/BoldItalic/JetBrainsMonoNerdFontMono-BoldItalic.ttf"
)

process_fonts() {
    local font_arr=("${@}")
    local font_dir

    for font in "${font_arr[@]}"; do
        font_dir="$jetbrains_dir"

        font_ttf=$(basename "$font")
        local_font="$font_dir/$font_ttf"

        if [[ -f "$local_font" ]]; then
            echo "$font_ttf already exists"
        else
            echo "Downloading $font_ttf..."
            curl -fL "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/$font" \
                -o "$local_font" || {
                echo "Failed to install $font_ttf"
                exit 1
            }
        fi
    done
}

process_fonts "${jetbrains_fonts[@]}"
