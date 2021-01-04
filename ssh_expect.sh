#!/bin/sh

ssh_expect()
{
	usrip=$1
	passwd=$2
	[ -z "`which expect`" ] && echo 'install expect first!' && exit 1
	expect <<EOF
	spawn ssh $usrip
	expect {
		"*yes/no" {send "yes\r"; exp_continue}
		"*password:" {send "$passwd\r"}
	}
	expect "# " 
	send "uptime &&  exit\r"
expect eof
EOF
}

ssh_expect $@
