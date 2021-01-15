#!/bin/bash
cp ./res/lib/systemd/system/dev_watch.service /lib/systemd/system/
cp ./res/usr/bin/dev_watch /usr/bin
systemctl enable dev_watch
systemctl restart dev_watch
