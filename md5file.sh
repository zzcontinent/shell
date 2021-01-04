#!/bin/bash


func_md5diff()
{
	file1="/tmp/cur.md5"
	file2="/tmp/pre.md5"
	echo "" > /tmp/md5.err
	cat $file1 | while read line
	do
		name1=$(echo "$line"|awk '{print $2}')
		md5_1=$(echo "$line"|awk '{print $1}')
		name2=$(grep " $name1$" $file2 | awk '{print $2}')
		md5_2=$(grep " $name1$" $file2 | awk '{print $1}')
		if [ -z "$name2" ];then
			echo "not in pre.md5:  $name1"
			func_ret=`expr $func_ret + 1`
		elif [ "$md5_1" != "$md5_2" ];then
			echo "not equal:  $name1 "
			func_ret=`expr $func_ret + 1`
		fi
	done|sort|tee /tmp/md5.err

	#file1 and file2 swap
	file1="/tmp/pre.md5"
	file2="/tmp/cur.md5"
	echo "" > /tmp/md5.err
	cat $file1 | while read line
	do
		name1=$(echo "$line"|awk '{print $2}')
		md5_1=$(echo "$line"|awk '{print $1}')
		name2=$(grep " $name1$" $file2 | awk '{print $2}')
		md5_2=$(grep " $name1$" $file2 | awk '{print $1}')
		if [ -z "$name2" ];then
			echo "not in pre.md5:  $name1"
		elif [ "$md5_1" != "$md5_2" ];then
			echo "not equal:  $name1 "
		fi
	done|sort|tee /tmp/md5.err

	#error detect
	if [ "`cat /tmp/md5.err`" == "" ];then
		echo "cur.md5 same as pre.md5"
	else
		echo "cur.md5 NOT same as pre.md5"
		return 1
	fi
}

try_cnt=0
while true;
do
	echo "$try_cnt:`date "+%Y-%m-%d_%H_%M_%S"`"

	rm -rf libraT-HIaarch64-19.09.15.02
	tar -zxpf libraT-HIaarch64-19.09.15.02.fgapp 
	find /home/deepglint/PKG/libraT-HIaarch64-19.09.15.02 -type f -exec md5sum {} \; > /tmp/cur.md5

	if [ $try_cnt -ne 0 ];then
		func_md5diff
		if [ $? -ne 0 ];then 
			echo "ERROR:not same!"
			exit 1
		else
			echo "SUCCEED:same!"
		fi
	fi
	cp /tmp/cur.md5 /tmp/pre.md5
	try_cnt=`expr $try_cnt + 1`
done

