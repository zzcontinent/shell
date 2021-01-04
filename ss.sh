#!/bin/bash
sslocal -c /home/cliff/data/software/ss/gui-config-4.json &

if [ "$1" == "pac" ];then
	genpac -p "SOCKS5 127.0.0.1:1080" --output="autoproxy.pac"
fi
