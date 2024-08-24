#!/bin/bash
if [ $# != 3 ] && [ $# != 4 ];then
	echo "sshtunnel.sh lport rip rport ssh"
	echo "sshtunnel.sh lport rport ssh"
	exit 1
fi

if [ $# == 3 ];then
	ssh -N -L $1:0.0.0.0:$2 $3
fi

if [ $# == 4 ];then
	ssh -N -L $1:$2:$3 $4
fi
