#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ~/{Downloads,Documents,Music,Pictures,Videos,Work}
USER_DIRS_CONFIG=~/.config/user-dirs.dirs
ln -s -f $DIR/user-dirs.dirs $USER_DIRS_CONFIG
xdg-user-dirs-update

SWAY_CONFIG_DIR=~/.config/sway
mkdir -p $SWAY_CONFIG_DIR
SWAY_CONFIG=$SWAY_CONFIG_DIR/config
ln -s -f $DIR/sway-config $SWAY_CONFIG

SWAYLOCK_CONFIG_DIR=~/.config/swaylock
mkdir -p $SWAYLOCK_CONFIG_DIR
SWAYLOCK_CONFIG=$SWAYLOCK_CONFIG_DIR/config
ln -s -f $DIR/swaylock-config $SWAYLOCK_CONFIG

ELECTRON_FLAGS_CONFIG=~/.config/electron-flags.conf
ln -s -f $DIR/electron-flags.conf $ELECTRON_FLAGS_CONFIG

# this is from: https://gist.github.com/cole-h/8aab0ed9d65efe38496e8e27b96b6a3d (but it doesn't seem to work in Alacritty)
FONTS_CONF_AVAIL_DIR=/etc/fonts/conf.avail
FONTS_CONF_D_DIR=/etc/fonts/conf.d
sudo cp $DIR/75-noto-color-emoji.conf $FONTS_CONF_AVAIL_DIR
sudo ln -s -f $FONTS_CONF_AVAIL_DIR/75-noto-color-emoji.conf $FONTS_CONF_D_DIR
# this is from: https://dev.to/darksmile92/get-emojis-working-on-arch-linux-with-noto-fonts-emoji-2a9 (and it makes it work in Alacritty)
FONTS_LOCAL_CONF=/etc/fonts/local.conf
sudo ln -s -f $DIR/fonts-local.conf $FONTS_LOCAL_CONF
fc-cache

mkdir -p "$(xdg-user-dir PICTURES)/screenshots"