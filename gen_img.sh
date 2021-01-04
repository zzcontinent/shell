#!/bin/bash

BLACK="\e[30;1m"
RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
PURPLE="\e[35;1m"
CYAN="\e[36;1m"
WHITE="\e[37;1m"
DONE="\033[0m"

#0 help
help(){
	echo "usage: gen_img [-appfs] [param0] [-datafs] [param1] [-rootfs] [param] "
	echo -e "paramx:
		-uboot        :\tbuild uboot from src/gitlab/FGLinux_HMV3/uboot/u-boot-2016.11
		-kernel       :\tbuild kernel from src/gitlab/FGLinux_HMV3/kernel/linux-4.9.y_multi-core
		-appfs  xG/xM :\tset appfs to xxG;
		-datafs xG/xM :\tset datafs to xxG;
		-rootfs xG/xM :\tset rootfs to xxG;
		-default      :\tappfs-3G datafs-10G rootfs-500M;
		"
}


APPFS_SIZE=""
DATAFS_SIZE=""
ROOTFS_SIZE=""
UBOOT_FLG=0
KERNEL_FLG=0

if [ $# == 0 ];then
	help
	exit 0
fi

until [ $# -eq 0 ]
do
	case "$1" in
	"-appfs")
		APPFS_SIZE="$2"
		shift 2
	;;
	"-datafs")
		DATAFS_SIZE="$2"
		shift 2
	;;
	"-rootfs")
		ROOTFS_SIZE="$2"
		shift 2
	;;
	"-uboot")
		UBOOT_FLG=1
		shift 
	;;
	"-kernel")
		KERNEL_FLG=1
		shift
	;;
	"-default")
		APPFS_SIZE="3G"
		DATAFS_SIZE="10G"
		ROOTFS_SIZE="500M"
		shift
	;;
	"-h"|"--help"|*)
		help
		shift
		exit 0
	;;
	esac
done

echo APPFS_SIZE=$APPFS_SIZE
echo DATAFS_SIZE=$DATAFS_SIZE
echo ROOTFS_SIZE=$ROOTFS_SIZE

# gen appfs datafs rootfs
if [ "$APPFS_SIZE" != "" ];then
	cmd="./osdrv/pub/bin/pc/make_ext4fs -L appfs -l $APPFS_SIZE -s ../pub/gen/app_${APPFS_SIZE}.ext4 ./gitlab/FGLinux_HMV3/appfs"
	echo -e ${RED}$cmd${DONE} &&
	$cmd 
fi
if [ "$DATAFS_SIZE" != "" ];then
	cmd="./osdrv/pub/bin/pc/make_ext4fs -L datafs -l $DATAFS_SIZE -s ../pub/gen/data_${DATAFS_SIZE}.ext4 ./gitlab/FGLinux_HMV3/datafs"
	echo -e ${RED}$cmd${DONE} &&
	$cmd 
fi
if [ "$ROOTFS_SIZE" != "" ];then
	cmd="./osdrv/pub/bin/pc/make_ext4fs -L rootfs -l $ROOTFS_SIZE -s ../pub/gen/rootfs_${ROOTFS_SIZE}.ext4 ./gitlab/FGLinux_HMV3/rootfs/rootfs_glibc_multi-core_arm64"
	echo -e ${RED}$cmd${DONE} &&
	$cmd && 


	cmd="./osdrv/pub/bin/pc/make_ext4fs -L rootfs -l $ROOTFS_SIZE  ../pub/gen/rootfs_${ROOTFS_SIZE}_raw.ext4 ./gitlab/FGLinux_HMV3/rootfs/rootfs_glibc_multi-core_arm64"
	echo -e ${RED}$cmd${DONE} &&
	$cmd 
fi

if [ $UBOOT_FLG -ne 0 ];then
	pushd ./osdrv/opensource/uboot && 
	cmd="tar -zcf u-boot-2016.11.tgz u-boot-2016.11" &&
	echo -e ${RED}$cmd${DONE} &&
	$cmd && 
	cmd="rm -r u-boot-2016.11" &&
	echo -e ${RED}$cmd${DONE} &&
	$cmd &&
	popd &&

	cmd="cp -r ./gitlab/FGLinux_HMV3/uboot/u-boot-2016.11 ./osdrv/opensource/uboot" &&
	echo -e ${RED}$cmd${DONE} &&
	$cmd &&

	pushd ./osdrv && 
	cmd="make BOOT_MEDIA=emmc AMP_TYPE=linux hiboot" &&
	echo -e ${RED}$cmd${DONE} &&
	$cmd &&

	cmd="cp ./pub/emmc_image_glibc_multi-core_arm64/u-boot-hi3559av100.bin ../../pub/gen/uboot.bin" &&
	echo -e ${RED}$cmd${DONE} &&
	$cmd &&
       	popd
fi

if [ $KERNEL_FLG -ne 0 ];then
	pushd ./osdrv/opensource/kernel && 
	cmd="rm -r linux-4.9.y_multi-core" &&
	echo -e ${RED}$cmd${DONE} &&
	$cmd &&
	popd && \

	cmd="cp -r ./gitlab/FGLinux_HMV3/kernel/linux-4.9.y_multi-core ./osdrv/opensource/kernel" &&
	echo -e ${RED}$cmd${DONE} &&
	$cmd &&
	pushd ./osdrv && 

	cmd="make BOOT_MEDIA=emmc AMP_TYPE=linux atf" &&
	echo -e ${RED}$cmd${DONE} &&
	$cmd &&

	cmd="cp ./pub/emmc_image_glibc_multi-core_arm64/uImage_hi3559av100_multi-core ../../pub/gen/kernel.bin" &&
	echo -e ${RED}$cmd${DONE} &&
	$cmd &&
       	popd
fi




