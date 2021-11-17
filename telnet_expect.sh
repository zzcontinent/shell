#!/usr/bin/expect
spawn telnet 192.168.1.26
expect "login:"
send "root\r"
expect "password:"
send "root\r"
expect "*# "
interact

