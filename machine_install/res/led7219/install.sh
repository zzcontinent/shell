#!/bin/bash
cd ./luma.led_matrix && python3 setup.py install ; cd -
cp ./res/lib/systemd/system/led7219.service /lib/systemd/system/
cp ./res/usr/bin/clock.py /usr/bin
systemctl enable led7219
systemctl restart led7219
