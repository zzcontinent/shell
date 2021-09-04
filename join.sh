#!/bin/bash

echo "input base file:"
read bfile
echo "input right file:"
read rfile
echo "input output file:"
read ofile

SEARCH_RANGE=1000
i=0
blen=`cat $bfile | wc -l`
for pc in `cat $bfile`
do
	printf "\r$i/$blen=`echo $i*100/$blen|bc`"
	i=`expr $i + 1`
	LLINE="$pc"
	RLINE="`grep "^$pc\:" $rfile`"
	FUNC_NAME="`grep -B${SEARCH_RANGE} "^$pc" $rfile | grep '<*>:' | tail -n 1`"
	echo "$LLINE -> ${FUNC_NAME} -> $RLINE" >> $ofile
done
cat $ofile | column -t > ${ofile}_t
echo
