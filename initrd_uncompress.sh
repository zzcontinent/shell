#!/bin/bash
apt install binwalk
binwalk ./initrd.img
dd if=./initrd.img bs=21111 skip=1 | lz4cat | cpio -idmv -D ./out_dir
