#!/bin/bash
#/**************************************install*****************************************************/
tsmv ()
{
    mv $1 $1_`date "+%y%m%d_%H%M%S"`
}

func_install()
{
	echo "
# 1
# gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig
# pacman-key -v archlinux-version-x86_64.iso.sig
#
# 2
# mount /dev/root_partition /mnt
# mount --mkdir /dev/efi_system_partition /mnt/boot
# swapon /dev/swap_partition
# pacstrap -K /mnt base linux linux-firmware
# genfstab -U /mnt >> /mnt/etc/fstab
# arch-chroot /mnt
# locale-gen
#
# /etc/locale.conf
# LANG=en_US.UTF-8
#
# /etc/vconsole.conf
# KEYMAP=de-latin1
#
# mkinitcpio
# passwd"
}

func_efibootmgr()
{
	echo "+++ func_efibootmgr +++"
	efibootmgr --create --disk /dev/sda --part 1 --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=/dev/sda3 resume=/dev/sda2 rw initrd=\initramfs-linux.img'
}

#/***************************************pacman backup****************************************************/
DST_PACMAN_BACKUP_SERVER_PATH="/home/cliff/backup/pacman/backup_server/pkg"
DST_PACMAN_BACKUP_SERVER_PATH_DB="$(dirname ${DST_PACMAN_BACKUP_SERVER_PATH})"

SRC_PACMAN_BACKUP_CURSYS_PATH="/var/cache/pacman/pkg"
DST_PACMAN_BACKUP_CURSYS_PATH="/home/cliff/backup/pacman/backup_cursys/pkg"
DST_PACMAN_BACKUP_CURSYS_PATH_DB="$(dirname ${DST_PACMAN_BACKUP_CURSYS_PATH})"

func_pacman_backup_server()
{
	PKGS="base  base-devel grub-bios \
xorg gimp efibootmgr gcc \
curl ctags git cmake rsync lftp okular terminator nmap \
fcitx5-im fcitx5-chinese-addons fcitx5-rime gnome-shell-extension-appindicator gnome-shell-extension-dash-to-panel \
nfs-utils git-lfs ttf-hack ttf-hack-nerd qemu-system-x86 adobe-source-han-sans-cn-fonts"
	echo "+++ func_pacman_backup_server +++"
	mkdir -p ${DST_PACMAN_BACKUP_SERVER_PATH}
	mkdir -p ${DST_PACMAN_BACKUP_SERVER_PATH_DB}
	#pacman -Syw --cachedir ${DST_PACMAN_BACKUP_SERVER_PATH} --dbpath ${DST_PACMAN_BACKUP_SERVER_PATH_DB} base base-devel grub-bios xorg gimp && \
	pacman -Syw --cachedir ${DST_PACMAN_BACKUP_SERVER_PATH} --dbpath ${DST_PACMAN_BACKUP_SERVER_PATH_DB}  --noconfirm ${PKGS} && \
	cd ${DST_PACMAN_BACKUP_SERVER_PATH} && repo-add ./custom.db.tar.gz ./*.zst &&\
	tar -cvf ${DST_PACMAN_BACKUP_SERVER_PATH_DB}.tar ${DST_PACMAN_BACKUP_SERVER_PATH_DB} &&\
	tsmv ${DST_PACMAN_BACKUP_SERVER_PATH_DB}.tar
}

func_pacman_backup_cursys()
{
	echo "+++ func_pacman_backup_cursys +++"
	mkdir -p ${DST_PACMAN_BACKUP_CURSYS_PATH}
	mkdir -p ${DST_PACMAN_BACKUP_CURSYS_PATH_DB}
	cd $(dirname ${SRC_PACMAN_BACKUP_CURSYS_PATH}) && tar -cvf ${DST_PACMAN_BACKUP_CURSYS_PATH_DB}.tar $(basename ${SRC_PACMAN_BACKUP_CURSYS_PATH}) && tsmv ${DST_PACMAN_BACKUP_CURSYS_PATH_DB}.tar
}

func_pacman_change_to_local_config()
{
echo "
# /etc/pacman.conf add custom before core and extra
[custom]
SigLevel = PackageRequired
Server = file://${DST_PACMAN_BACKUP_SERVER_PATH}"
}

#/***************************************pacman backup****************************************************/

#/**************************************boot uefi*****************************************************/
func_run()
{
	if [ -z "$1" ];then
		echo "arch.sh efi            : efibootmgr"
		echo "arch.sh baks           : backup_server to ${DST_PACMAN_BACKUP_SERVER_PATH_DB}"
		echo "arch.sh bakc           : backup_cursys from ${SRC_PACMAN_BACKUP_CURSYS_PATH} to ${DST_PACMAN_BACKUP_CURSYS_PATH_DB}"
		echo "arch.sh change_local   : change to local config"
		echo "arch.sh wiki           : wiki"
	elif [ "$1" == "wiki" ];then
		func_install
	elif [ "$1" == "efi" ];then
		func_efibootmgr
	elif [ "$1" == "baks" ];then
		func_pacman_backup_server
	elif [ "$1" == "bakc" ];then
		func_pacman_backup_cursys
	elif [ "$1" == "change_local" ];then
		func_pacman_change_to_local_config
	fi
}

func_run $@

