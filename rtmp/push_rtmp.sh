#!/bin/bash

IN_FILE=$1
OUT_PUSH_PATH=$2
OUT_RESOLUTION=$3

([ -z $IN_FILE ] || [ -z $OUT_PUSH_PATH ]) && echo 'push_rtmp.sh IN_FILE OUT_PUSH_PATH OUT_RESOLUTION' && exit 1
[ -z $OUT_RESOLUTION ] && OUT_RESOLUTION=240

#ffmpeg -re -i $IN -vcodec libx264 -vprofile baseline -acodec aac -ar 44100 -strict -2 -ac 1 -f flv rtmp://192.168.2.235:1935/live/$NAME
#ffmpeg -re -i $IN -f flv rtmp://192.168.2.235:1935/live/$NAME
#ffmpeg -re -i $IN -vcodec libx264 -preset:v ultrafast -tune:v zerolatency -f flv rtmp://192.168.2.235:1935/live/$NAME
#ffmpeg -re -i $IN -vcodec libx264 -preset:v ultrafast -f flv rtmp://192.168.2.235:1935/live/$NAME
umount /tmp/hls 2>/dev/null
mount -t tmpfs tmpfs /tmp/hls
ffmpeg -re -i $IN_FILE -vcodec libx264 -preset:v ultrafast -acodec aac -ar 44100 -strict -2 -ac 1 -vf scale=-2:${OUT_RESOLUTION} -f flv rtmp://192.168.2.235:1935/live/${OUT_PUSH_PATH}
umount /tmp/hls 2>/dev/null
