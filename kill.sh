#!/bin/bash
if [ -z $1 ];then
	echo "input process name"
	exit 1
fi
pids=`ps aux | grep $1 | grep -v grep | awk '{print $2}'`
for pid in $pids
do
	kill -9 $pid
done
