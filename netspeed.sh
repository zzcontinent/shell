eth_name=`cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/^[\t]*//g' | sed 's/[:]*$//g' | grep -e '^e.*'`
wifi_name=`cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/^[\t]*//g' | sed 's/[:]*$//g' | grep -e '^w.*'`
speed_notify=500
while true 
do
   	#记录初始bytes数目
	if [ "$wifi_name" != "" ];then
			down_speed_old_wifi=`ifconfig $wifi_name  | sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p'`
        	up_speed_old_wifi=`ifconfig $wifi_name  | sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p'`
	fi
	if [ "$eth_name" != "" ];then
	        #记录初始bytes数目
       		down_speed_old_eth=`ifconfig $eth_name  | sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p'`
	        up_speed_old_eth=`ifconfig $eth_name | sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p'`
	fi

	sleep 1

	if [ "$wifi_name" != "" ];then
       		#保存最新的bytes数目
       		down_speed_now_wifi=`ifconfig $wifi_name  | sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p'`
	        up_speed_now_wifi=`ifconfig $wifi_name  | sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p'`

	        #计算下行与上行的网速
        	down_speed_wifi=`echo "($down_speed_now_wifi-$down_speed_old_wifi)/1024"|bc`
	        up_speed_wifi=`echo "($up_speed_now_wifi-$up_speed_old_wifi)/1024"|bc`
	fi
	if [ "$eth_name" != "" ];then
        	#保存最新的bytes数目
        	down_speed_now_eth=`ifconfig $eth_name  | sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p'`
        	up_speed_now_eth=`ifconfig $eth_name  | sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p'`

        	#计算下行与上行的网速
        	down_speed_eth=`echo "($down_speed_now_eth-$down_speed_old_eth)/1024"|bc`
        	up_speed_eth=`echo "($up_speed_now_eth-$up_speed_old_eth)/1024"|bc`

	fi
	printf "\033c"	
   	printf "$eth_name\tDN:%5sKB/s | UP:%5sKB/s \n" $down_speed_eth $up_speed_eth 
	printf "$wifi_name\tDN:%5sKB/s | UP:%5sKB/s" $down_speed_wifi $up_speed_wifi 
	time=`date "+%Y-%m-%d %H:%M:%S"`
	if [ $down_speed_wifi -gt $speed_notify -o $up_speed_wifi -gt $speed_notify ];then
		notify-send "$time wifi DN:$down_speed_wifi|UP:$up_speed_wifi" > /dev/null 2>&1
		echo -e "\a"
	fi
	if [ $down_speed_eth -gt $speed_notify -o $up_speed_eth -gt $speed_notify ];then
		notify-send "$time eth DN:$down_speed_eth|UP:$up_speed_eth" > /dev/null 2>&1
		echo -e "\a"
	fi
done

