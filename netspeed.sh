eth_name=`cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/^[\t]*//g' | sed 's/[:]*$//g' | grep -e '^e.*'`
wifi_name=`cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/^[\t]*//g' | sed 's/[:]*$//g' | grep -e '^w.*'`
echo $eth_name $wifi_name
echo $@
while true 
do
        #记录初始bytes数目
	if [ "$wifi_name" != "" ];then
		down_speed_old=`ifconfig $wifi_name  | sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p'`
        	up_speed_old=`ifconfig $wifi_name  | sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p'`

	        sleep 1

       		#保存最新的bytes数目
       		down_speed_now=`ifconfig $wifi_name  | sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p'`
	        up_speed_now=`ifconfig $wifi_name  | sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p'`

	        #计算下行与上行的网速
        	down_speed=`echo "($down_speed_now-$down_speed_old)/1024"|bc`
	        up_speed=`echo "($up_speed_now-$up_speed_old)/1024"|bc`


	       	#echo -ne "\rwifi \tDN:$down_speed KB/s\tUP:$up_speed KB/s"
       		printf "\rwifi \tDN:%6s KB/s\tUP:%6s KB/s" $down_speed $up_speed 
	fi
	if [ "$eth_name" != "" ];then
	        #记录初始bytes数目
       		down_speed_old=`ifconfig $eth_name  | sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p'`
	        up_speed_old=`ifconfig $eth_name | sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p'`

       		sleep 1

        	#保存最新的bytes数目
        	down_speed_now=`ifconfig $eth_name  | sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p'`
        	up_speed_now=`ifconfig $eth_name  | sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p'`

        	#计算下行与上行的网速
        	down_speed=`echo "($down_speed_now-$down_speed_old)/1024"|bc`
        	up_speed=`echo "($up_speed_now-$up_speed_old)/1024"|bc`

        	#echo -ne "\reth \tDN:$down_speed KB/s\tUP:$up_speed KB/s"
       		printf "\reth \tDN:%6s KB/s\tUP:%6s KB/s" $down_speed $up_speed 
	fi
done

