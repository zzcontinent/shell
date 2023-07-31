#local retransmit
#=======> add
#sudo iptables -t nat -A OUTPUT -d 10.0.0.2 -p tcp --dport 11211 -j DNAT --to-destination 192.168.1.33:11211
#=======> list
#sudo iptables -nL --line-number -t nat
#=======> delete
#sudo iptables -D OUTPUT 2 -t nat

#保存
iptables -S

#查看
#iptables -nvL --line-number

#屏蔽70-72网段到执行该命令的机器的包
#iptables -A INPUT -s 10.47.180.70/72 -j DROP (ACCEPT恢复)

#屏蔽70到执行该命令的机器的包
#iptables -A INPUT -s 10.47.180.70 -j DROP (ACCEPT恢复)


#该命令将 eth0 网卡的传输设置为延迟 100 毫秒发送
tc qdisc add dev eth0 root netem delay 100ms
tc qdisc add dev eth0 root netem delay 100ms 10ms (90-100ms)
tc qdisc add dev eth0 root netem delay 100ms 10ms 30% (30% +- 10ms)
#模拟网络丢包
tc qdisc add dev eth0 root netem loss 1%
#随机产生 1% 的重复数据包
tc qdisc add dev eth0 root netem duplicate 1%
#该命令将 eth0 网卡的传输设置为随机产生 0.2% 的损坏的数据包
tc qdisc add dev eth0 root netem corrupt 0.2%
#eth0 网卡的传输设置为:有 25% 的数据包(50%相关)会被立即发送,其他的延迟10 秒
tc qdisc change dev eth0 root netem delay 10ms reorder 25% 50%
#查看
tc qdisc show dev eth0
#删除
tc qdisc del dev eth0 root

#limit bandwidh
sudo tc qdisc add dev enp0s3 root tbf rate 100000kbit burst 16kbit latency 50ms
