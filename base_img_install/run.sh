#!/bin/bash
FILE_LEN=73

# common env ----------------------------------
TOPDIR="$(dirname $0)"
cd $TOPDIR

RUN_FILE=run.sh
RES_DIR=res
OUT_PACK=out_run

func_unpack()
{
	echo "+++ func_unpack +++"
	tail -n +`expr $FILE_LEN + 1` $OUT_PACK > $RES_DIR.tgz
	rm -r $RES_DIR
	tar -zxf $RES_DIR.tgz
	rm $RES_DIR.tgz 2>/dev/null
}

func_deb_install()
{
	echo "+++ func_deb_install +++"
	export LC_ALL=C
	cp $RES_DIR/etc/apt/sources.list /etc/apt/
	apt update
	apt install libterm-readkey-perl -y
	apt install fuse -y
	apt install apt-utils -y
	apt install bash-completion -y
	apt install lsb-release -y
	apt install busybox -y
	apt install iputils-ping -y
	apt install htop -y
	apt install jq -y
	apt install less -y
	apt install curl -y
	apt install module-init-tools -y
	apt install net-tools -y
	apt install netplan.io -y
	apt install nfs-common -y
	apt install ssh -y
	apt install squashfs-tools -y
	apt install sudo -y
	apt install tree -y
	apt install udev -y
	apt install tzdata -y
	apt install usbutils -y
	apt install wget -y
	apt install ntpdate -y
	apt install zlib1g -y
	apt install zlib1g-dev -y
	apt upgrade -y
}

func_config()
{
	echo "+++ func_config +++"
	timedatectl set-timezone Asia/Shanghai
	netplan apply
	passwd root
}

func_copy_files()
{
	echo "+++ func_copy_files +++"
	cp -a $RES_DIR/* /
}
func_unpack
func_deb_install
func_copy_files
func_config

exit 0
