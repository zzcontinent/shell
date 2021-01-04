#!/bin/bash

CONF_NET_DEV=wlan0
[ ! -z $1 ] && CONF_NET_DEV="$1"

IP=""
func_is_ip_miss()
{
	ip0="$(ifconfig $CONF_NET_DEV 2>/dev/null | grep inet | awk 'NR==1 {print $2}')"
	ip1="$(ifconfig $CONF_NET_DEV 2>/dev/null | grep inet | awk -F':' 'NR==1 {print $2}' | cut -f1 -d' ')"
	if [ -z $ip0 ] && [ -z $ip1 ];then
		return 1
	fi
	[ ! -z $ip0 ] && IP=$ip0
	[ ! -z $ip1 ] && IP=$ip1
	return 0
}

check_miss_cnt_max=5
check_miss_cnt=$check_miss_cnt_max
while true
do
	func_is_ip_miss
	if [ $? != 0 ];then
		echo "$IP => $CONF_NET_DEV ip missed, reboot in ${check_miss_cnt} ... "
		check_miss_cnt=`expr $check_miss_cnt - 1`
		[ $check_miss_cnt -eq 0 ] && reboot
	else
		check_miss_cnt=$check_miss_cnt_max
		echo "$IP => $CONF_NET_DEV ip exists, no need reboot"
	fi
	sleep 60
done
