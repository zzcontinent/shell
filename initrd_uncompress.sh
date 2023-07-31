#!/bin/bash
apt install binwalk
binwalk ./initrd.img
dd if=./initrd.img bs=21111 skip=1 | lz4cat | cpio -idmv -D ./out_dir

|--cpio

解压cpio文件 cpio -idmv < filename.cpio
同样可以解压img文件：cpio -idmv < filename.imgcpio
备份命令备份：cpio -covB > [file|device]
将数据备份到文件或设备上还原：cpio -icduv < [file|device}
将数据还原到系统中常用参数：-o   ：将数据copy到文件或设备上


-i   ：将数据从文件或设备上还原到系统中
-t   ：查看cpio建立的文件或设备内容
-c   ：一种比较新的portable format方式存储
-v   ：在屏幕上显示备份过程中的文件名
-B   ：让预设的blocks可以增加到5120bytes，\
　　　　默认是512bytes，这样可以使备份速度加快
-d   ：自动建立目录，这样还原时才不会出现找不到路径的问题
-u   ：更新，用较新的文件覆盖旧的文件cpio常与find 配合使用

|--cpio解压方法：
    1.  # gunzip  XXX.cpio.gz
    2.   cpio -idmv < XXX.cpio

|--制作cpio格式文件系统的方法：
    1. 执行gen_initramfs_list.sh脚本：
       #gen_initramfs_list.sh ./Filesystem/ >filelist
       其中Filesystem文件夹是由上一步解压出来的cpio文件系统目录
    2. 执行gen_init_cpio产生cpio文件：
       #gen_init_cpio filelist >rootfs.cpio
    3. 压缩cpio生成cpio.gz文件：
       #gzip rootfs.cpio

|--所使用文件说明：

gen_initramfs_list.sh：用于产生filelist
gen_init_cpio.c ：工具gen_init_cpio的源码，编译后可以用
gen_init_cpio：用于产生cpio格式文件系统的可执行文件
