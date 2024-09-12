#!/bin/bash
echo $#

if [ $# -eq 0 ];then
	echo "./run.sh r     -- run docker archlinux from images"
	echo "./run.sh e cmd -- exec into container bash"
	echo "./run.sh rs    -- restart container"
	exit 1
elif [ x"$1" == "xr" ];then
	docker run -itd \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=unix$DISPLAY \
		-e GDK_SCALE \
		-e GDK_DPI_SCALE \
		--name archlinux \
		--restart=unless-stopped \
		-v /home/cliff/workspace/ai_workspace/root/:/root/ \
		archlinux
		#--rm \
elif [ x"$1" == "xe" ];then
	docker exec -it archlinux $2
elif [ x"$1" == "xrs" ];then
	docker restart archlinux
fi

