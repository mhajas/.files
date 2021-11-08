#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ZLOGIN_CONFIG=~/.zlogin
ln -s -f $DIR/zlogin $ZLOGIN_CONFIG

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

MAKO_CONFIG_DIR=~/.config/mako
mkdir -p $MAKO_CONFIG_DIR
MAKO_CONFIG=$MAKO_CONFIG_DIR/config
ln -s -f $DIR/mako-config $MAKO_CONFIG

ELECTRON_FLAGS_CONFIG=~/.config/electron-flags.conf
ln -s -f $DIR/electron-flags.conf $ELECTRON_FLAGS_CONFIG