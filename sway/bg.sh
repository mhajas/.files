#!/usr/bin/env bash

WALLPAPERS_DIR="$HOME/Pictures/wallpapers"
if [ -d "$WALLPAPERS_DIR" ] && [ -n "$(ls "$WALLPAPERS_DIR" 2>/dev/null)" ]
then
	swaymsg "output * bg $WALLPAPERS_DIR/$(ls "$WALLPAPERS_DIR" | sort -R | tail -1) fill"
else
	swaymsg "output * bg /usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill"
fi