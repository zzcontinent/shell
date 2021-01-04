#!/bin/sh

DATE=`date '+%2y.%m.%d.01'`
TARGET=DELinux_HMV3_${DATE}
rm -r ${TARGET}
mkdir -p ${TARGET}

echo "+++ copy base +++"
cp ./base/* ${TARGET}/

echo "+++ copy gen +++"
cp ../gen/config ${TARGET}/
cp ../gen/kernel_64M_A ${TARGET}/kernel_64M
cp ../gen/rootfs.dpk ${TARGET}/rootfs.dpk
cp ../gen/rootfs_13000M.ext4 ${TARGET}/rootfs_13000M.ext4

echo "+++ tar ${TARGET}.tgz +++"
tar -zcvf ${TARGET}.tgz ${TARGET}

echo "+++ md5sum +++"
md5sum ${TARGET}.tgz
