#!/bin/bash

FILE=$1
if [ -z $FILE ];then
	echo 'input filename'
	exit
fi
OPT=$2

func_empty_line()
{
	echo "+++ $FUNCNAME +++"
	sed -i '/^$/d' $FILE
}

func_space_tab()
{
	echo "+++ $FUNCNAME +++"
	#space tab
	sed -i '/^[[:space:]]*$/d' $FILE
	#sed -i 's/ //g' $FILE
}

func_tail_space()
{
	echo "+++ $FUNCNAME +++"
	sed -i 's/ *$//g' $FILE
}

func_foot_empty_line()
{
	echo "+++ $FUNCNAME +++"
}

if [ -z $OPT ];then
	func_tail_space
	#func_foot_empty_line
elif [ $OPT == 1 ];then
	func_empty_line
elif [ $OPT == 2 ];then
	func_space_tab
else
	func_tail_space
	#func_foot_empty_line
fi
