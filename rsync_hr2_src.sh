#!/bin/bash

SRC_PATH="/mnt/c/tmp/./hr2_src"
DES_PATH="host_cliff:/home/cliff/hcworkspace/"
EXCLUDE=""
#IS_DELETE="--delete"
IS_DELETE=""

#1 ===================================================
retry_cnt=0
RETRY_MAX=1
while [ $retry_cnt -lt $RETRY_MAX ]
do
	echo -e "\ntry `expr $retry_cnt + 1` time--------------------------------------------------------------------\n"
	echo "+++ $SRC_PATH ==> $DES_PATH +++"
	for x in $SRC_PATH
	do
		echo "+++ $x ==> $REMOTE_SSH +++"
		rsync -aRPvhl ${IS_DELETE} --exclude={"${EXCLUDE}"} $x $DES_PATH
	done
	if [ $? -eq 0 ];then
		break
	else
		retry_cnt=`expr $retry_cnt + 1`
		continue
	fi
done
