#!/bin/bash
if [ -z $1 ];then
	echo "input process name"
	exit 1
fi

pids=`ps aux | grep $1 | grep -Ev "grep|$0 $*" | awk '{print $2}'`
[ -z "$pids" ] && echo NONE && exit 1
for p in $pids
do
	ps -p $p
	kill -9 $p
done
