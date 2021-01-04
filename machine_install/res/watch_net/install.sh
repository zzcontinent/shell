#!/bin/bash
cp ./watch_net.service /lib/systemd/system/
cp ./watch_net.sh /usr/bin
ln -s /lib/systemd/system/watch_net.service /etc/systemd/system/watch_net.service
systemctl enable watch_net
systemctl restart watch_net
