#config host
#sudo smbpasswd -a dg
#/etc/samba/smb.conf
#[dgsh_share]
#comment=dgsh share doc
#path=/home/dg/Documents
#create mask=0755
#directory mask=0755
#writeable=yes
#valid users=dg
#browseable=yes

#explore
#smbclient -L //172.17.0.2 -N

#client mount
sudo mount.cifs  //172.17.0.2/dgsh_share /media/pi  -o user=dg,pass=dg2018
