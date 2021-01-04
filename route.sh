1.主机路由
# route add -host 192.168.1.2 dev eth0
# route add -host 10.20.30.148 gw 10.20.30.40     #添加到10.20.30.148的网管

2.网络路由
# route add -net 10.20.30.40 netmask 255.255.255.248 eth0   #添加10.20.30.40的网络
# route add -net 10.20.30.48 netmask 255.255.255.248 gw 10.20.30.41 #添加10.20.30.48的网络
# route add -net 192.168.1.0/24 eth1
3.默认路由
#route add default gw 172.17.0.1
4.删除路由
# route del -host 192.168.1.2 dev eth0:0
# route del -host 10.20.30.148 gw 10.20.30.40
# route del -net 10.20.30.40 netmask 255.255.255.248 eth0
# route del -net 10.20.30.48 netmask 255.255.255.248 gw 10.20.30.41
# route del -net 192.168.1.0/24 eth1
# route del default gw 192.168.1.1
5.设置转发
# vi /etc/sysctl.conf
net.ipv4.ip_forward = 1
sysctl net.ipv4.ip_forward
