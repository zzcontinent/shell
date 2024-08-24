#!/bin/bash

docker run -d --name calibre-web -p 8083:8083 -e PUID=1000 -e PGID=1000 --restart=always -v /home/cliff/workspace/reader_workspace/config:/config -v /home/cliff/workspace/reader_workspace/data:/books  lscr.io/linuxserver/calibre-web
