#!/usr/bin/env sh
if ! pgrep -u $UID ^swaylock$; then
	swaymsg mode locked \
		&& swaylock -s center -i ~/.files/sway/lock.png \
		&& swaymsg mode default
fi