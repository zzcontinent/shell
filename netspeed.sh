#！/bin/bash
# version 1　　2017-08-14

while true 
do
        #记录初始bytes数目
        down_speed_old=`ifconfig wlp2s0  | sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p'`
        up_speed_old=`ifconfig wlp2s0  | sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p'`

        sleep 1

        #保存最新的bytes数目
        down_speed_now=`ifconfig wlp2s0  | sed -n 's/RX.*bytes \([0-9]\+\).*/\1/p'`
        up_speed_now=`ifconfig wlp2s0  | sed -n 's/TX.*bytes \([0-9]\+\).*/\1/p'`

        #计算下行与上行的网速
        down_speed=`echo "($down_speed_now-$down_speed_old)/1024"|bc`
        up_speed=`echo "($up_speed_now-$up_speed_old)/1024"|bc`


        #echo "speed : \n\tDN : $[(($down_speed_now-$down_speed_old))] B/s \t $down_speed KB/s"
        echo -ne "\rDN : $down_speed KB/s UP : $up_speed KB/s"
        #echo "\tUP : $[(($up_speed_now-$up_speed_old))] B/s \t $up_speed KB/s"
done
