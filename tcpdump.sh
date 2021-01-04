#proto dir type ID


#类型 type
#host, net, port, portrange
#
#例如：host 192.168.201.128 , net 128.3, port 20, portrange 6000-6008'
#
#目标 dir
#src, dst, src or dst, src and dst
#
#协议 proto
#tcp， udp ， icmp，若未给定协议类型，则匹配所有可能的类型
#host foo and not port ftp and not port ftp-data

#sample
sudo tcpdump -c 10 -q -XX -vvv -nn -i enp8s0 tcp dst port 8
