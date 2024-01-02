#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ALACRITTY_CONFIG=~/.config/alacritty/alacritty.toml
mkdir -p $(dirname $ALACRITTY_CONFIG)
ln -s -f $DIR/alacritty.toml $ALACRITTY_CONFIG

