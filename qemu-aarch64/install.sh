#!/bin/sh

#step 1
apt-get install qemu-system-arm
apt-get install qemu-system-aarch64
apt-get install qemu-efi-aarch64
apt-get install qemu-utils


#step 2
dd if=/dev/zero of=flash1.img bs=1M count=64
dd if=/dev/zero of=flash0.img bs=1M count=64
dd if=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd of=flash0.img conv=notrunc

#step 3
# 3.1 for accelerated vms
qemu-system-aarch64 -enable-kvm -m 1024 -cpu host -M virt -nographic -pflash flash0.img -pflash flash1.img -drive if=none,file=focal-server-cloudimg-arm64.img,id=hd0 -device virtio-blk-device,drive=hd0 -netdev type=tap,id=net0 -device virtio-net-device,netdev=net0,mac=$randmac

# 3.2 for emulated vms
qemu-system-aarch64 -m 2048 -cpu cortex-a72 -M virt -nographic -pflash flash0.img -pflash flash1.img -drive if=none,file=focal-server-cloudimg-arm64.img,id=hd0 -device virtio-blk-device,drive=hd0 -netdev type=tap,id=net0 -device virtio-net-device,netdev=net0,mac=$randmac

#step 4
#qemu-img info rootfs.img
#qemu-img resize rootfs.img 20G









#wget http://ports.ubuntu.com/ubuntu-ports/dists/bionic-updates/main/installer-arm64/current/images/netboot/mini.iso
#
##step 4
#qemu-img create ubuntu-image.img 20G
#
##step 5 ( start qemu with the installer, install ubuntu to the ubuntu-image.img )
#qemu-system-aarch64 -nographic -machine virt,gic-version=max -m 512M -cpu max -smp 4 \
#-netdev user,id=vnet,hostfwd=:127.0.0.1:0-:22 -device virtio-net-pci,netdev=vnet \
#-drive file=ubuntu-image.img,if=none,id=drive0,cache=writeback -device virtio-blk,drive=drive0,bootindex=0 \
#-drive file=mini.iso,if=none,id=drive1,cache=writeback -device virtio-blk,drive=drive1,bootindex=1 \
#-drive file=flash0.img,format=raw,if=pflash -drive file=flash1.img,format=raw,if=pflash
#
#
##step 6 ( restart qemu without installer )
#qemu-system-aarch64 -nographic -machine virt,gic-version=max -m 512M -cpu max -smp 4 \
#-netdev user,id=vnet,hostfwd=:127.0.0.1:0-:22 -device virtio-net-pci,netdev=vnet \
#-drive file=ubuntu-image.img,if=none,id=drive0,cache=writeback -device virtio-blk,drive=drive0,bootindex=0 \
#-drive file=flash0.img,format=raw,if=pflash -drive file=flash1.img,format=raw,if=pflash
