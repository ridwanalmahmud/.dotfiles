#!/usr/bin/env bash

FONT_PATH=$HOME/.local/share/fonts

argon_dir=$FONT_PATH/monaspace_argon
radon_dir=$FONT_PATH/monaspace_radon

mkdir -p $argon_dir
mkdir -p $radon_dir

argon_fonts=(
    "Monaspace%20Argon/MonaspaceArgonNF-Light.otf"
    "Monaspace%20Argon/MonaspaceArgonNF-LightItalic.otf"
    "Monaspace%20Argon/MonaspaceArgonNF-Regular.otf"
    "Monaspace%20Argon/MonaspaceArgonNF-Italic.otf"
    "Monaspace%20Argon/MonaspaceArgonNF-SemiBold.otf"
    "Monaspace%20Argon/MonaspaceArgonNF-SemiBoldItalic.otf"
    "Monaspace%20Argon/MonaspaceArgonNF-Bold.otf"
    "Monaspace%20Argon/MonaspaceArgonNF-BoldItalic.otf"
)

radon_fonts=(
    "Monaspace%20Radon/MonaspaceRadonNF-Light.otf"
    "Monaspace%20Radon/MonaspaceRadonNF-LightItalic.otf"
    "Monaspace%20Radon/MonaspaceRadonNF-Regular.otf"
    "Monaspace%20Radon/MonaspaceRadonNF-Italic.otf"
    "Monaspace%20Radon/MonaspaceRadonNF-SemiBold.otf"
    "Monaspace%20Radon/MonaspaceRadonNF-SemiBoldItalic.otf"
    "Monaspace%20Radon/MonaspaceRadonNF-Bold.otf"
    "Monaspace%20Radon/MonaspaceRadonNF-BoldItalic.otf"
)

process_fonts() {
    local font_arr=("${@}")
    local font_dir

    for font in "${font_arr[@]}"; do
        if [[ "$font" == *"Argon"* ]]; then
            font_dir="$argon_dir"
        else
            font_dir="$radon_dir"
        fi

        font_otf=$(basename "$font")
        local_font="$font_dir/$font_otf"

        if [ -f "$local_font" ]; then
            echo "$font.otf already exists"
        else
            echo "Downloading $font_otf..."
            curl -fL "https://github.com/githubnext/monaspace/raw/HEAD/fonts/NerdFonts/$font" \
                -o "$local_font" || {
                echo "Failed to install $font_otf"
                exit 1
            }
        fi
    done
}

process_fonts "${argon_fonts[@]}"
process_fonts "${radon_fonts[@]}"
