#!/bin/bash
echo $#

if [ $# -eq 0 ];then
	echo "./buildroot.sh d  -- run docker ubuntu:16.04 from images"
	echo "./buildroot.sh c  -- exec into container bash"
	echo "./buildroot.sh b  -- build thead buildroot"
	exit 1

elif [ x"$1" == "xd" ];then
	docker run -itd \
		-v /home/backup/pi/workspace/rvworkspace/thead:/mnt \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=unix$DISPLAY \
		-e GDK_SCALE \
		-e GDK_DPI_SCALE \
		--name test123 \
		--net=host \
		ubuntu:16.04 \
		bash

elif [ x"$1" == "xc" ];then
	docker exec -it test123 bash
elif [ x"$1" == "xb" ];then
	cd ./buildroot && make CONF=thead_9xxf_enhanced_5.10_glibc_br_defconfig
fi
