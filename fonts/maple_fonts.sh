#!/usr/bin/env bash

set -e

FONT_PATH=$HOME/.local/share/fonts

maple_dir=$FONT_PATH/maple_mono
maple_zip=$FONT_PATH/maple_fonts.zip

mkdir -p $maple_dir

if [[ ! -f "$maple_dir/config.json" && ! -f "$maple_dir/LICENSE.txt" ]]; then
    curl -fL https://github.com/subframe7536/maple-font/releases/download/v7.7/MapleMono-NF.zip -o $maple_zip || {
        echo "Failed to install $font_otf"
        exit 1
    }
    unzip $maple_zip -d $maple_dir
    rm -rf $maple_zip
else
    echo "Maple fonts already exists"
fi
