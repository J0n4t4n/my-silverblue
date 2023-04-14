#!/bin/sh
if test "$(id -u)" -gt "0" && test -d "$HOME"; then
    if test ! -e "$HOME"/.config/autostart/yafti.desktop; then
        mkdir -p "$HOME"/.config/autostart
        cp -f /etc/skel/.config/autostart/yafti.desktop "$HOME"/.config/autostart
    fi
fi
