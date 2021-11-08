#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

THEMES_DIR=/usr/share/bumblebee-status/themes/michal-sway-theme.json
sudo ln -s -f $DIR/michal-sway-theme.json $THEMES_DIR

MODULES_DIR=/usr/share/bumblebee-status/bumblebee_status/modules/contrib
for MODULE in $DIR/custom-modules/* ; do
    sudo ln -s -f "$MODULE" "$MODULES_DIR/$(basename "$MODULE")" 
done
