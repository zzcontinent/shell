#!/bin/bash
cpucnt=$1
freqmin=$2
freqmax=$3

if [ -z $(which cpupower 2>/dev/null) ];then
	if [ $# == 0 ];then
		cpufreq-info
		exit 0
	elif [ $# != 3 ];then
		echo "freq.sh cpucnt minfreq maxfreq"
		exit 1
	else
		for i in `seq 0 $(expr ${cpucnt} - 1)`
		do
			cpufreq-set -c $i --min ${freqmin} --max ${freqmax}
		done
	fi
else
	if [ $# == 0 ];then
		cpupower frequency-info
		cpupower frequency-info -o
		exit 0
	elif [ $# != 3 ];then
		echo "freq.sh cpucnt minfreq maxfreq"
		exit 1
	else
		for i in `seq 0 $(expr ${cpucnt} - 1)`
		do
			cpupower -c $i frequency-set --min ${freqmin} --max ${freqmax}
		done
	fi
fi


