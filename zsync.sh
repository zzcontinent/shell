#1. gen .zsync
#zsyncmake libmali.so -u http://172.17.0.51:9000/sys/FileServe?FileFullPath=/root/libmali.so


#2. get by url
zsync  http://172.17.0.51:9000/sys/FileServe?FileFullPath=/root/libmali.so.zsync -k libmali.so.zsync

#3. get by .zsync file
zsync libmali.so.zsync

