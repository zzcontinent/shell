#!/bin/bash
PID="`ps -ax | grep 'indicator-sysmonitor' |grep -v grep | awk '{print $1}'`"
echo "$$"
echo '--------'
echo -n "$PID"
for i in "$PID";
do
	kill -9 $i >/dev/null 2>&1
done

indicator-sysmonitor >/dev/null 2>&1 &
exit 0
