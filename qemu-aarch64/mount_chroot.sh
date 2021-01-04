#!/bin/bash
MOUNT_DIR='delinux_rootfs_squash_18.04'
MOUNT_SRC='delinux_rootfs_18.04.current.img'
[ -z $1 ] && echo '
usage:
mount_chroot.sh -r : umount all
mount_chroot.sh -i : mount all and chroot' && exit 1

if [ $1 == "-i" ];then
	mount $MOUNT_SRC $MOUNT_DIR

	mount -t proc -o defaults,nodev,nosuid proc $MOUNT_DIR/proc
	mount -t sysfs -o defaults,nodev,nosuid sysfs $MOUNT_DIR/sys
	mount -t tmpfs tmpfs $MOUNT_DIR/dev

	mknod $MOUNT_DIR/dev/console c 5 1
	mknod $MOUNT_DIR/dev/ttyAMA0 c 204 64
	mknod $MOUNT_DIR/dev/ttyS000 c 204 64
	mknod $MOUNT_DIR/dev/null	   c 1 3
	mkdir $MOUNT_DIR/dev/pts
	#mount -t devpts devpts $MOUNT_DIR/dev/pts

	mknod $MOUNT_DIR/dev/urandom c 1 9
	mknod $MOUNT_DIR/dev/random c 1 8
	mount --bind /dev/pts $MOUNT_DIR/dev/pts
	mount --bind /dev/urandom $MOUNT_DIR/dev/urandom
	mount --bind /dev/random $MOUNT_DIR/dev/random
	chroot $MOUNT_DIR
elif [ $1 == '-r' ];then
	umount $MOUNT_DIR/dev/urandom
	umount $MOUNT_DIR/dev/random
	umount $MOUNT_DIR/dev/pts 
	umount $MOUNT_DIR/dev
	umount $MOUNT_DIR/sys
	umount $MOUNT_DIR/proc
fi
