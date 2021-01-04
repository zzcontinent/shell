#!/bin/bash

(
jq -V
[ $? != 0 ] && echo "install jq first!" && sudo apt install jq
tr --version
[ $? != 0 ] && echo "install tr first!" && exit 1
sshpass -V
[ $? != 0 ] && echo "install sshpass first!" && sudo apt install sshpass
) >/dev/null

func_gen_osinfo()
{
	echo "+++ func_gen_osinfo +++"
	json_template='{"name":"name","version":"ver"}'
	jq_template='.name=$arg1 | .version=$arg2'
	Name=`cat dfuinfo | jq .osName | tr -d '"'`
	Version=`cat dfuinfo | jq .osVersion | tr -d '"'`
	echo ${json_template} | jq --arg arg1 $Name  --arg arg2 $Version "${jq_template}" > osinfo 
	return 0
}

func_gen_appinfo()
{
	echo "+++ func_gen_appinfo +++"
	json_template='{"name":"name","version":"ver"}'
	jq_template='.name=$arg1 | .version=$arg2'
	Name=`cat dfuinfo | jq .appName | tr -d '"'`
	Version=`cat dfuinfo | jq .appVersion | tr -d '"'`
	echo ${json_template} | jq --arg arg1 $Name  --arg arg2 $Version "${jq_template}" > appinfo
	return 0
}

func_push_files()
{
	echo "+++ func_push_files +++"
	IP=192.168.12.12
	IP=172.17.0.52
	DIR='/home/deepglint/PKG'
	for x in `ls`
	do
		if [ $x != dfuinfo ] && [ $x != auto_gen_scp.sh ];then
			echo "+++ pushing $x into $IP:$DIR +++"
			sshpass -pOn1shiuva4 scp -o StrictHostKeyChecking=no $x root@${IP}:${DIR}
		fi
	done
}

func_gen_osinfo
func_gen_appinfo
func_push_files

