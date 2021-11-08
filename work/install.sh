#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WORK_DIRECTORY=~/Work
if [ ! -d "$WORK_DIRECTORY" ]; then
    mkdir -p $WORK_DIRECTORY
fi

REPOSITORIES=$(cat "$DIR"/repositories)
REMOTES=$(cat "$DIR"/remotes)
ORIGIN=mhajas

# Checkout keycloak repositories
cd "$WORK_DIRECTORY" || exit

for REPO in $REPOSITORIES
do
    cd "$WORK_DIRECTORY" || exit
    if [ ! -d "$WORK_DIRECTORY/$REPO" ]; then
        git clone "git@github.com:$ORIGIN/$REPO.git"
        cd "$REPO" || exit

        for REMOTE in $REMOTES
        do
            user_name=$(echo "$REMOTE" | cut -d':' -f1)
            remote_name=$(echo "$REMOTE" | cut -d':' -f2)

            git remote add "$remote_name" "git@github.com:$user_name/$REPO.git"
        done
    fi
done

MVN_SETTINGS_DIR=~/.m2
mkdir -p $MVN_SETTINGS_DIR
SWAY_CONFIG=$MVN_SETTINGS_DIR/settings.xml
ln -s -f $DIR/settings.xml $SWAY_CONFIG

# TODO: Add to a separate git module
git config --global oh-my-zsh.hide-status 1
git config --global oh-my-zsh.hide-dirty 1
git config --global user.email "mhajas@redhat.com"
git config --global user.name "Michal Hajas"

systemctl --user enable wireplumber.service
systemctl --user enable xdg-desktop-portal xdg-desktop-portal-wlr
systemctl --user enable pipewire.socket pipewire
