#!/bin/bash
if [ x"$1" == "xkill" ];then
	kill.sh 'python -m http.server'
elif [ $# == 2 ];then
	python -m http.server --directory $1  $2 &
elif [ $# == 0 ];then
	echo "http_server.sh dir port"
fi
