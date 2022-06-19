#!/bin/bash

sudo apt install mysql-server-8.0
sudo systemctl start mysql

#get user and password
cat /etc/mysql/debian.cnf

mysql -udebian-sys-maint -pxxx

#show database;
#use mysql;
#select host, user, authentication_string from user;
#alter user 'root'@localhost idnetified by '520020895';
#flush privileges;
#exit;

mysql -uroot -p520020895;

#install navicat
wget http://download.navicat.com.cn/download/navicat16-premium-cs.AppImage
