#!/bin/bash

#for docker service
systemctl set-environment HTTP_PROXY=http://127.0.0.1:7890 HTTPS_PROXY=http://127.0.0.1:7890
systemctl restart docker


#wayland display scale to 150%
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
systemctl restart gdm
open Settings > Devices > Displays (the new options may only appear after a restart).

#xorg
#install mutter-x11-scaling aur
gsettings set org.gnome.mutter experimental-features "['x11-randr-fractional-scaling']"
#chrome input
chromium --enable-features=UseOzonePlatform --ozone-platform=wayland --gtk-version=4
$ cat environment
#
# This file is parsed by pam_env module
#
# Syntax: simple "KEY=VAL" pairs on separate lines
#
XIM=fcitx5
XIM_PROGRAM=fcitx5
GTK_IM_MODULE=fcitx5
QT_IM_MODULE=fcitx5
XMODIFIERS=@im=fcitx5
GLFW_IM_MODULE=fcitx5
# /usr/share/applications/chromium.desktop
Exec=/usr/bin/chromium %U --gtk-version=4

