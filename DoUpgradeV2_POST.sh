#!/bin/bash
ip=$1
[ -z $ip ] && echo 'input dev ip' && exit 1
uuid=$(curl $ip:9000/api/GetDeviceInfo 2>/dev/null | grep UUID|cut -d':' -f2| cut -d'"' -f2)
sk=$(echo -n "deepglint$uuid"|md5sum|cut -d' ' -f1)
data="{\"SecretKey\":\"${sk}\"}"
echo $data
cmd="curl -X POST -H Content-Type:application/json ${ip}:9000/api/DoUpgradeV2  -d $data"
resp="`$cmd 2>/dev/null`"
echo $resp
