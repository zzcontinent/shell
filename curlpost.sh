ip=$1
appname=$2
if [ -z $ip ] || [ -z $appname ];then
	echo 'input ip appname' > /dev/stderr
	exit 1
fi

uuid=$(curl $1:9000/api/GetDeviceInfo 2>/dev/null | grep UUID|cut -d':' -f2| cut -d'"' -f2)
sk=$(echo -n "deepglint$uuid"|md5sum|cut -d' ' -f1)
data="{\"AppName\":\"$2\",\"SecretKey\":\"${sk}\"}"
cmd="curl -X POST -H Content-Type:application/json ${ip}:9000/api/Curapp  -d $data"
resp="`$cmd 2>/dev/null`"
ok=`echo $resp | grep 200`
echo $ok
if [ -z "$ok" ];then
	echo 'failed!'
	exit 1
else
	echo 'succeed!'
	exit 0
fi
