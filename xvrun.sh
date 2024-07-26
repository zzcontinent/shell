#!/bin/bash
#trap "kill 0" 1 2 5 9 15

if [ $# -eq 0 ];then
	echo "./xvrun.sh r display x11app -- run app"
	echo "./xvrun.sh s display        -- run x0vncserver on display"
	exit 1
fi

if [ x"$1" == "xr" ];then
	echo "xvfb-run -s "-screen 0 1920x1080x24" -n $2 $3"
	xvfb-run -s "-screen 0 1920x1080x24" -n $2 $3
elif [ x"$1" == "xs" ];then
	echo "x0vncserver -display :$2 -PasswordFile ~/.vnc/passwd"
	x0vncserver -display :$2 -PasswordFile ~/.vnc/passwd
fi
