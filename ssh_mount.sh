#!/bin/bash

if [ "x$1" == "xun" ];then
	umount /media/pi
	exit
elif [ "x$1" == "xmnt" ];then
	sshfs pi:/home/backup/pi  /media/pi
else
	echo "ssh_mount.sh mnt (mount pi on /media/pi)"
	echo "ssh_mount.sh un (unmount /media/pi)"
fi



