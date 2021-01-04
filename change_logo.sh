#!/bin/bash
token=$(curl -H 'Content-Type:application/json' http://192.168.12.12/api/login -d '{"userName":"admin","password":"27a3388aedc1dfaa7a94e7223a0fa1c1"}' -v 2>/dev/null| grep token|cut -d':' -f2|cut -d'"' -f2)

curl -X PUT -H 'Content-Type:application/json' -H "Authorization:Bearer ${token}" http://192.168.12.12/api/system/logo -d '{"loginText":"嵌入式人脸识别系统"}'
