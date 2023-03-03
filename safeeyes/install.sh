#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SAFEEYES_CONFIG=~/.config/safeeyes/safeeyes.json
mkdir -p $(dirname $SAFEEYES_CONFIG)
ln -s -f $DIR/config $SAFEEYES_CONFIG