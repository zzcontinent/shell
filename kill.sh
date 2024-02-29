#!/bin/bash
if [ $# == 0 ];then
	echo "input process name"
	exit 1
fi

a="$*"

pids=`ps aux | grep "$a" | grep -Ev "grep" | awk '{print $2}'`
[ -z "$pids" ] && echo NONE && exit 1
for p in $pids
do
	ps -p $p
	kill -9 $p
done
