#!/bin/bash
mailbox="zzcontinent@163.com"

get_pubip() {
	echo -n `curl ip4.me 2>/dev/null` | sed 's/.*>\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/g'
}

send_mail() {
	curip=$(get_pubip)
	if [ -z ${curip} ];then
		echo 'fetch pubip failed, retrying...'
		sleep 1
		send_mail
	else
		echo "pubip is ${curip}, now sending email to ${mailbox}"
		echo ${curip} | mutt -s 'pubip' ${mailbox}
	fi
}

send_mail
