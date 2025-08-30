#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

section() {
    echo -e "\n${BLUE}===${NC} ${GREEN}$1${NC} ${BLUE}===${NC}"
}

status() {
    echo -e "${YELLOW}➔${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1" >&2
}

FONT_PATH=$HOME/.dotfiles/fonts/JetBrainsMono

section "Add Fonts"
status "Creating local fonts directory"
mkdir -p $FONT_PATH || {
    error "Failed to create directory"
    exit 1
}

status "Installing JetBrains Nerd Fonts..."
jetbrains_fonts=(
    JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFontMono-Regular.ttf
    JetBrainsMono/Ligatures/Italic/JetBrainsMonoNerdFontMono-Italic.ttf
    JetBrainsMono/Ligatures/Medium/JetBrainsMonoNerdFontMono-Medium.ttf
    JetBrainsMono/Ligatures/MediumItalic/JetBrainsMonoNerdFontMono-MediumItalic.ttf
    JetBrainsMono/Ligatures/Bold/JetBrainsMonoNerdFontMono-Bold.ttf
    JetBrainsMono/Ligatures/BoldItalic/JetBrainsMonoNerdFontMono-BoldItalic.ttf
    JetBrainsMono/Ligatures/Light/JetBrainsMonoNerdFontMono-Light.ttf
    JetBrainsMono/Ligatures/LightItalic/JetBrainsMonoNerdFontMono-LightItalic.ttf
    JetBrainsMono/Ligatures/Thin/JetBrainsMonoNerdFontMono-Thin.ttf
    JetBrainsMono/Ligatures/ThinItalic/JetBrainsMonoNerdFontMono-ThinItalic.ttf
)

for font in "${jetbrains_fonts[@]}"; do
    font_ttf=$(basename "$font")
    curl -fL "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/$font" \
        -o $FONT_PATH/$font_ttf || {
        error "Failed to install $font_ttf"
        exit 1
    }
done

status "Renaming fonts"
for file in $FONT_PATH/*; do
    if [ -f "$file" ]; then
        font_ttf=$(basename "$file")
        if [[ "$font_ttf" == JetBrainsMonoNerdFontMono-* ]]; then
            new_name="${font_ttf#JetBrainsMonoNerdFontMono-}"
            mv -v "$file" "$FONT_PATH/$new_name" >/dev/null 2>&1 || {
                error "Failed renaming $font_ttf -> $new_name"
                exit 1
            }
            echo "Renamed: $font_ttf -> $new_name"
        fi
    fi
done
success "Renaming complete!"

