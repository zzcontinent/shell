#!/bin/bash 

SYNC_PATH="/home/cliff/Projects /home/cliff/dgworkspace /home/cliff/data /root/qemu-ubuntu-aarch64 /home/cliff/shell"
REMOTE_SSH="pi_235:/home/backup/y7000"
LOCAL_SSH="pi_local:/home/backup/y7000"
EXCLUDE="/home/cliff/data/dgftp /home/cliff/data/dgnfs /home/cliff/data/tftpd"

#1 ===================================================
LOG_FILE=`date "+%Y-%m-%d"`
retry_cnt=0
RETRY_MAX=5
cd /home/cliff/tmp
echo > $LOG_FILE
while [ $retry_cnt -lt $RETRY_MAX ] 
do
	echo -e "\ntry `expr $retry_cnt + 1` time--------------------------------------------------------------------\n" >> $LOG_FILE
	if [ x"$1" == x"local" ];then
		echo "+++ $SYNC_PATH ==> $LOCAL_SSH +++"
		for x in $SYNC_PATH
		do
			echo "+++ $x ==> $LOCAL_SSH +++"
			sudo rsync -azRPvhl --delete --exclude={"${EXCLUDE}"} $x $LOCAL_SSH 2>&1 >> $LOG_FILE
		done
	else
		echo "+++ $SYNC_PATH ==> $REMOTE_SSH +++"
		for x in $SYNC_PATH
		do
			echo "+++ $x ==> $REMOTE_SSH +++"
			sudo rsync -azRPvhl --delete --exclude={"${EXCLUDE}"} $x $REMOTE_SSH 2>&1 >> $LOG_FILE
		done
	fi
	if [ $? -eq 0 ];then
		break
	else
		retry_cnt=`expr $retry_cnt + 1`
		continue
	fi
done
