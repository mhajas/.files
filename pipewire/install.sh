#!/usr/bin/env bash

systemctl --user enable wireplumber.service
systemctl --user enable xdg-desktop-portal xdg-desktop-portal-wlr
systemctl --user enable pipewire.socket pipewire
