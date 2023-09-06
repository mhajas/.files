#!/usr/bin/env bash

gammastep -m wayland -r >& /dev/null &

swaync >& /dev/null &

kanshi >& /dev/null &

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 >& /dev/null &

ferdium --auth-server-whitelist *.redhat.com >& /dev/null &

spotify >& /dev/null &

env RUST_BACKTRACE=1 RUST_LOG=swayr=debug swayrd > /tmp/swayrd.log 2>&1 &

safeeyes >& /dev/null  &

solaar --window=hide >& /dev/null &

