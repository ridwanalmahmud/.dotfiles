#!/usr/bin/env bash

RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get terminal width
cols=$(tput cols)

# ASCII art lines (without colors for width calculation)
visca=(
    "█╗    ██╗██╗███████╗ ██████╗ █████╗"
    "██║   ██║██║██╔════╝██╔════╝██╔══██╗"
    "██║   ██║██║███████╗██║     ███████║"
    "╚██╗ ██╔╝██║╚════██║██║     ██╔══██║"
    " ╚████╔╝ ██║███████║╚██████╗██║  ██║"
    "  ╚═══╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝"
)

barca=(
    "██████╗  █████╗ ██████╗  ██████╗ █████╗ "
    "██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗"
    "██████╔╝███████║██████╔╝██║     ███████║"
    "██╔══██╗██╔══██║██╔══██╗██║     ██╔══██║"
    "██████╔╝██║  ██║██║  ██║╚██████╗██║  ██║"
    "╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"
)

# Calculate max line length (VISCA and BARCA side by side)
max_len=0
for i in {0..5}; do
    combined_len=$((${#visca[i]} + ${#barca[i]}))
    (( combined_len > max_len )) && max_len=$combined_len
done

# Calculate padding
padding=$(( (cols - max_len) / 2 ))

echo -e "\n"

# Print centered ASCII art
for i in {0..5}; do
    printf "%*s" $padding ""
    echo -e "${BLUE}${visca[i]}${NC}  ${RED}${barca[i]}${NC}"
done

echo -e "\n"
