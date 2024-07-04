#!/bin/bash

#for docker service
systemctl set-environment HTTP_PROXY=http://127.0.0.1:7890 HTTPS_PROXY=http://127.0.0.1:7890
systemctl restart docker


#wayland display scale to 150%
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
systemctl restart gdm
open Settings > Devices > Displays (the new options may only appear after a restart).
