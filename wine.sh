#!/bin/sh

pacman -S wine

cd ${WINEPREFIX:-~/.wine}/drive_c/windows/Fonts && for i in /usr/share/fonts/**/*.{ttf,otf}; do ln -s "$i"; done
winetricks corefonts
winetricks allfonts
winetricks gdiplus riched20 riched30
