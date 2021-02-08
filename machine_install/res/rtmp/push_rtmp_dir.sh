#!/bin/bash


IN_FILE=$1
OUT_PUSH_PATH=$2
OUT_RESOLUTION=$3
IN_LOOP=$4
IN_RANDOM=$5

([ -z $IN_FILE ] || [ -z $OUT_PUSH_PATH ]) && echo 'push_rtmp_dir.sh IN_FILE OUT_PUSH_PATH [OUT_RESOLUTION] [IN_LOOP] [IN_RANDOM]' && exit 1

[ -z $DIR ] && DIR=.

func_play()
{
	if [ -d $IN_FILE ];then
		files_order=($(ls $IN_FILE))
		cnt=${#files_order[@]}
		index=0
		if [ ! -z $IN_RANDOM ];then
			echo "+++ random play +++" 
			for x in `seq $cnt`
			do
				index=$(echo `gen_rand.sh`%$cnt | bc)
				echo "+++ playing  [$index/$cnt] | ${files_order[$index]} +++"
				sleep 3
				push_rtmp.sh  $IN_FILE/${files_order[$index]} $OUT_PUSH_PATH $OUT_RESOLUTION
			done
		else
			echo "+++ seq play +++" 
			for x in ${files_order[@]}
			do
				echo "+++ playing [$index/$cnt] | ${x} +++"
				index=`expr $index + 1`
				sleep 3
				push_rtmp.sh  $IN_FILE/$x $OUT_PUSH_PATH $OUT_RESOLUTION
			done
		fi
	else
		push_rtmp.sh $IN_FILE $OUT_PUSH_PATH $OUT_RESOLUTION
	fi
}


if [ ! -z $IN_LOOP ];then
	(
	echo "+++ loop mode +++"
	while true
	do
		func_play
		sleep 3
	done
	) &
else
	echo "+++ once mode +++"
	func_play &
fi
