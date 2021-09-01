#!/bin/bash

echo "input base file:"
read bfile
echo "input right file:"
read rfile

i=0
blen=`cat $bfile | wc -l`
for pc in `cat $bfile`
do
	printf "\r$i/$blen=`echo $i*100/$blen|bc`"
	i=`expr $i + 1`
	echo -n "$pc -> " >> join.txt; 
	grep -B200 "^$pc" $rfile | grep '<*>:' | tail -n 1 >> join.txt; 
done
echo
