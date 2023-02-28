#!/bin/bash

# - Position the Cursor:
#  \033[<L>;<C>H
#     Or
#  \033[<L>;<C>f
#  puts the cursor at line L and column C.
#- Move the cursor up N lines:
#  \033[<N>A
#- Move the cursor down N lines:
#  \033[<N>B
#- Move the cursor forward N columns:
#  \033[<N>C
#- Move the cursor backward N columns:
#  \033[<N>D
#
#- Clear the screen, move to (0,0):
#  \033[2J
#- Erase to end of line:
#  \033[K
#
#- Save cursor position:
#  \033[s
#- Restore cursor position:
#  \033[u


#net_devs=`ifconfig -s | awk '{i++; if(i>1){print $1}}' | awk '{print $1}'`
net_devs=`ifconfig | grep flags | awk -F':' '{print $1}'`
#net_devs=`cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/[:]*$//g'`
speed_notify=1024
PERIOD=2
TMP_FILE_FB="${HOME}/.tmp_netspeed"
#TMP_FILE_FB="/run/user/$(id -u)/.tmp_netspeed"
[ ! -f ${TMP_FILE_FB} ] && touch ${TMP_FILE_FB}

net_devs_ok=""

for dev in ${net_devs}
do
	if [ -z "`echo $dev | grep -E '\-|\:|\.'`" ];then
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
	date "+%Y-%m-%d %H:%M:%S"
	for dev in ${net_devs_ok}
	do
		eval rx_cur_${dev}=`ifconfig ${dev}  2>/dev/null| sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p' | awk '{print $1}'`
		eval tx_cur_${dev}=`ifconfig ${dev}  2>/dev/null| sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p' | awk '{print $1}'`

		eval rx_speed_${dev}=`echo "($(eval echo '$'rx_cur_${dev})-$(eval echo '$'rx_pre_${dev}))/1024/${PERIOD}"|bc`
		eval tx_speed_${dev}=`echo "($(eval echo '$'tx_cur_${dev})-$(eval echo '$'tx_pre_${dev}))/1024/${PERIOD}"|bc`

		printf "%-15s | DN:%10sKB/s | UP:%10sKB/s \n" ${dev} $(eval echo '$'rx_speed_${dev}) $(eval echo '$'tx_speed_${dev})
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

func_cursor_up()
{
	printf "\033[%dA" $1
}

func_cursor_down()
{
	printf "\033[%dB" $1
}

func_cursor_forward()
{
	printf "\033[%dC" $1
}

func_cursor_backward()
{
	printf "\033[%dD" $1
}

func_set_cursor()
{
	row=$1
	col=$2
	printf "\33[%d;%dH" $1 $2
}


func_run()
{
	func_step_total > ${TMP_FILE_FB}
	line=`cat ${TMP_FILE_FB} | wc -l`
	while true
	do
		sleep ${PERIOD}
		echo -n > ${TMP_FILE_FB}
		func_step_total > ${TMP_FILE_FB}
		cat ${TMP_FILE_FB}
		func_cursor_up ${line}
		#func_step_pids
		#cat ${TMP_FILE_FB} | column -t
		#if [ $down_speed_wifi -gt $speed_notify -o $up_speed_wifi -gt $speed_notify ];then
		#	notify-send "$time wifi DN:$down_speed_wifi|UP:$up_speed_wifi" > /dev/null 2>&1
		#	echo -e "\a"
		#fi
		#if [ $down_speed_eth -gt $speed_notify -o $up_speed_eth -gt $speed_notify ];then
		#	notify-send "$time eth DN:$down_speed_eth|UP:$up_speed_eth" > /dev/null 2>&1
		#	echo -e "\a"
		#fi
	done
}

func_run_log()
{
	while true
	do
		echo -n > ${TMP_FILE_FB}
		func_step_total
		cat ${TMP_FILE_FB} | column -t
		sleep ${PERIOD}
	done
}

#func_step_total
func_run
#func_run_log
