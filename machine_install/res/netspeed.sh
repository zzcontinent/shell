#!/bin/bash
net_devs=`ifconfig -s | awk '{i++; if(i>1){print $1}}' | awk '{print $1}'`
#net_devs=`cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/[:]*$//g'`
speed_notify=1024
PERIOD=1
TMP_FILE_FB="${HOME}/.tmp_netspeed"
[ ! -f ${TMP_FILE_FB} ] && touch ${TMP_FILE_FB}

net_devs_ok=""

for dev in ${net_devs}
do
	if [ -z "`echo $dev | grep -E '\-|\:|\.'`" ];then
		echo $dev
		net_devs_ok="${net_devs_ok} ${dev}"
	fi
done

for dev in ${net_devs_ok}
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

func_step_total()
{
	date "+%Y-%m-%d %H:%M:%S" >> ${TMP_FILE_FB}
	for dev in ${net_devs_ok}
	do
		eval rx_cur_${dev}=`ifconfig ${dev}  | sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p' | awk '{print $1}'`
		eval tx_cur_${dev}=`ifconfig ${dev}  | sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p' | awk '{print $1}'`

		eval rx_speed_${dev}=`echo "($(eval echo '$'rx_cur_${dev})-$(eval echo '$'rx_pre_${dev}))/1024/${PERIOD}"|bc`
		eval tx_speed_${dev}=`echo "($(eval echo '$'tx_cur_${dev})-$(eval echo '$'tx_pre_${dev}))/1024/${PERIOD}"|bc`

		printf "%10s | DN:%10sKB/s | UP:%10sKB/s \n" ${dev} $(eval echo '$'rx_speed_${dev}) $(eval echo '$'tx_speed_${dev}) >> ${TMP_FILE_FB}
		eval rx_pre_${dev}=$(eval echo '$'rx_cur_${dev})
		eval tx_pre_${dev}=$(eval echo '$'tx_cur_${dev})
	done
}

func_step_pids()
{
	echo  >> ${TMP_FILE_FB}
	sudo netstat  -alnp | grep -E '^tcp|^udp' | sort -rn -k3 | head -n 3 >> ${TMP_FILE_FB}
	sudo netstat  -alnp | grep -E '^tcp|^udp' | sort -rn -k2 | head -n 3 >> ${TMP_FILE_FB}
}


func_run()
{
	while true
	do
		echo -n > ${TMP_FILE_FB}
		printf "\033c"
		func_step_total
		#func_step_pids
		cat ${TMP_FILE_FB}
		#if [ $down_speed_wifi -gt $speed_notify -o $up_speed_wifi -gt $speed_notify ];then
		#	notify-send "$time wifi DN:$down_speed_wifi|UP:$up_speed_wifi" > /dev/null 2>&1
		#	echo -e "\a"
		#fi
		#if [ $down_speed_eth -gt $speed_notify -o $up_speed_eth -gt $speed_notify ];then
		#	notify-send "$time eth DN:$down_speed_eth|UP:$up_speed_eth" > /dev/null 2>&1
		#	echo -e "\a"
		#fi
		sleep ${PERIOD}
	done
}

func_step_total
func_run
