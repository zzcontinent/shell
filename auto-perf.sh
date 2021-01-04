#!/bin/bash
if [ $# -ne 2 ];then 
	echo "param len must be 2: pid second"
	exit 1
fi

sudo perf record -e cpu-clock -g -p $1 -- sleep $2 &&  
sudo perf script -i ./perf.data > ./perf.unfold && 
/home/cliff/cworkspace/github/FlameGraph/stackcollapse-perf.pl ./perf.unfold > ./perf.folded && 
/home/cliff/cworkspace/github/FlameGraph/flamegraph.pl ./perf.folded > ./perf.svg 
chromium-browser ./perf.svg
