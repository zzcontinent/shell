#!/bin/bash
[ $1 ] && curl wttr.in/$1 && exit 0
curl wttr.in
#curl wttr.in/nanjing
