#!/bin/bash

if [ "x$1" == "xkill" ];then
	pkill -e -f clash-linux-amd64
	exit 0
else
	echo -n > ~/.clash.log
	clash-linux-amd64 -f /home/backup/pi/wiki/clash.yaml.txt >> ~/.clash.log &
fi

