#!/bin/bash

[ "x$1" == "xkill" ] && pkill -e -f clash-linux-amd64 && exit 0

echo -n > ~/.clash.log
clash-linux-amd64 -f /home/backup/pi/wiki/clash.yaml.txt >> ~/.clash.log &

