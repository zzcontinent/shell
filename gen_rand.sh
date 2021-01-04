#!/bin/sh
bytes=2
hexdump -n$bytes -e'"%d"' /dev/urandom
