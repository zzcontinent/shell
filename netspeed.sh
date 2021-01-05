#!/bin/bash
net_devs=`ifconfig -s | awk '{i++; if(i>1){print $1}}' | awk '{print $1}'`
#net_devs=`cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/[:]*$//g'`
speed_notify=1024

for dev in ${net_devs}
do
	eval rx_pre_${dev}='0'
	eval tx_pre_${dev}='0'
	eval rx_cur_${dev}='0'
	eval tx_cur_${dev}='0'
	eval rx_speed_${dev}='0'
	eval tx_speed_${dev}='0'
	#eval rx_pre_${dev}='123'
	#echo $(eval echo '$'rx_pre_${dev})
done

func_step_once()
{
	for dev in ${net_devs}
	do
		eval rx_cur_${dev}=`ifconfig ${dev}  | sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p' | awk '{print $1}'`
		eval tx_cur_${dev}=`ifconfig ${dev}  | sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p' | awk '{print $1}'`

		eval rx_speed_${dev}=`echo "($(eval echo '$'rx_cur_${dev})-$(eval echo '$'rx_pre_${dev}))/1024"|bc`
		eval tx_speed_${dev}=`echo "($(eval echo '$'tx_cur_${dev})-$(eval echo '$'tx_pre_${dev}))/1024"|bc`

		printf "%10s | DN:%10sKB/s | UP:%10sKB/s \n" ${dev} $(eval echo '$'rx_speed_${dev}) $(eval echo '$'tx_speed_${dev})
		eval rx_pre_${dev}=$(eval echo '$'rx_cur_${dev})
		eval tx_pre_${dev}=$(eval echo '$'tx_cur_${dev})
	done
}


func_run()
{
	while true
	do
		time=`date "+%Y-%m-%d %H:%M:%S"`
		printf "\033c"
		func_step_once
		sleep 1
		#if [ $down_speed_wifi -gt $speed_notify -o $up_speed_wifi -gt $speed_notify ];then
		#	notify-send "$time wifi DN:$down_speed_wifi|UP:$up_speed_wifi" > /dev/null 2>&1
		#	echo -e "\a"
		#fi
		#if [ $down_speed_eth -gt $speed_notify -o $up_speed_eth -gt $speed_notify ];then
		#	notify-send "$time eth DN:$down_speed_eth|UP:$up_speed_eth" > /dev/null 2>&1
		#	echo -e "\a"
		#fi
		sleep 1
	done
}

func_step_once
func_run
