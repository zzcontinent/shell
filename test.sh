#!/bin/bash 
echo $$
echo $#
echo $0
echo x"$*"x
echo y"$@"y
exit 0
try5()
{
	cnt=0
	cnt_max=5
	echo $@
	while true;
	do
		$@
		[ $? -eq 0 ] && return 0
		cnt=`expr $cnt + 1`
		if [ $cnt -ge $cnt_max ];then
			return 1
		fi
		sleep 1
	done
}

try5 cat /proc/cmdline1
echo $?
try5 cat /proc/cmdline
echo $?

exit 0
cat /proc/`echo $$`/status | grep -E 'Uid|Gid'
echo $0 $$
retry_cnt=0
RETRY_MAX=100
while [ $retry_cnt -lt $RETRY_MAX ] 
do
	retry_cnt=`expr $retry_cnt + 1`
	printf "\rretry `expr $retry_cnt + 1` time----------------------------------" 
	sleep 1
done

#y=1 2 3 4 5 2 3 4 5
y=(1 2 3 4 5)
y='1 2 3 4 5'
for x in ${y[@]}
do
	echo -
	echo $x
done
