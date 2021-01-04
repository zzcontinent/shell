#!/bin/bash
ip=$1
[ -z $ip ] && echo 'input dev ip' && exit 1
curl -X GET $ip:9000/api/UpgradeProgress
