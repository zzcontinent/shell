#!/bin/bash

docker run -d --rm --name calibre-web -p 8083:8083 -e PUID=1000 -e PGID=1000  -v /home/cliff/workspace/reader_workspace/data:/books  lscr.io/linuxserver/calibre-web
