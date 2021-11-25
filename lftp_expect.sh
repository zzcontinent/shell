#!/usr/bin/expect
spawn lftp root@192.168.1.26
expect "Password: "
send "root\r"
expect "*~> "
interact


