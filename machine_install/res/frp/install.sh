#!/bin/sh
mkdir -p /etc/frp
cp ./frp_0.34.1_linux_arm/frpc /usr/bin/
cp ./frp_0.34.1_linux_arm/frps /usr/bin/
cp ./frpc.ini /etc/frp
cp ./frps.ini /etc/frp
cp frpc.service /lib/systemd/system/
cp frps.service /lib/systemd/system/
rm -f /etc/systemd/system/frpc.service
rm -f /etc/systemd/system/frps.service
ln -s /lib/systemd/system/frpc.service /etc/systemd/system/frpc.service
ln -s /lib/systemd/system/frps.service /etc/systemd/system/frps.service
