#!/bin/bash 

#0 help
help(){
	echo "usage: ./rsync_pi.sh path"
}

if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ $# -ne 1 ] || [ ! -s $1 ] ;then
	help
	exit 1
fi

#1 ===================================================
rsync -azRPvhl $1 pi_remote:/home/backup/y7000 | tee ./`date "+%Y-%m-%d_%H:%M:%S"`
