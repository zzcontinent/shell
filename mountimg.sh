#!/bin/sh
[ xx$1 == 'xx' ] && echo 'input img first!!' && exit 1
section_cnt=`fdisk -l $1 | grep "^$1" | wc -l`
for cnt in `seq $section_cnt`
do
	offset=$(fdisk -l $1 | grep $1$cnt | tr '*' ' ' | awk '{print $2}')
	len=$(fdisk -l $1 | grep $1$cnt | awk '{print $4}')
	img=$(fdisk -l $1 | grep $1$cnt | awk '{print $1}')
	echo "$img ==> $offset : $len  "
	mkdir -p ./tmp$cnt
	[ ! -f ./$cnt.img ] && dd if=$1 of=./$cnt.img skip=$offset count=$len conv=notrunc
	#dd seek (output offset)
	sudo mount ./$cnt.img ./tmp$cnt
done 
