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

ln -s -f $WORK_DIRECTORY/keycloak/.github/scripts/pr-backport.sh $DIR/bin/kc-pr-backport

