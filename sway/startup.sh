#!/usr/bin/env bash

gammastep -m wayland -r >& /dev/null &

mako >& /dev/null &

kanshi >& /dev/null &

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 >& /dev/null &

ferdium --auth-server-whitelist *.redhat.com >& /dev/null &

morgen >& /dev/null &

spotify >& /dev/null &

