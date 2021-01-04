CMD1="/home/cliff/data/dgnfs *(rw,sync,no_subtree_check)"
CMD2="/home/cliff/tmp *(rw,sync,no_subtree_check)"
EXISTS1=`grep -F "$CMD1" /etc/exports`
EXISTS2=`grep -F "$CMD2" /etc/exports`
echo ${EXISTS1}
echo ${EXISTS2}
if [ -z "${EXISTS1}" ];then
	echo "$CMD1" >> /etc/exports
fi
if [ -z "${EXISTS2}" ];then
	echo "$CMD2" >> /etc/exports
fi

systemctl restart nfs-server.service

#for client
#sudo apt install nfs-kernel-server
#sudo mount -t nfs -o nolock,vers=4 172.17.0.107:/home/cliff/tmp /mnt
