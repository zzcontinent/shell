#!/bin/bash
if [ $# == 1 ];then
	curl -X GET $1:9000/api/GetDeviceInfo
fi
