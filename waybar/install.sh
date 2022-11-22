#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WAYBAR_CONFIG=~/.config/waybar/config
mkdir -p $(dirname $WAYBAR_CONFIG)
ln -s -f $DIR/waybar-config $WAYBAR_CONFIG


WAYBAR_STYLE=~/.config/waybar/style.css
mkdir -p $(dirname $WAYBAR_STYLE)
ln -s -f $DIR/../themes/current/waybar/style.css $WAYBAR_STYLE

# theme 
THEME=~/.config/waybar/theme.css
mkdir -p $(dirname $THEME)
ln -s -f $DIR/../themes/current/waybar/theme.css $THEME