#1 qemu related
#kvm -smp 2 -m 1500 -netdev user,id=mynet0,hostfwd=tcp::8022-:22,hostfwd=tcp::8090-:80 -device virtio-net-pci,netdev=mynet0 -vga qxl -drive file=ubuntu-core-18-amd64.img,format=raw

#2 build kernel
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabi-
#export CROSS_COMPILE=arm-linux-gnueabihf-
make clean
make vexpress_defconfig
make menuconfig (qemu specific: disable --> Enable the L2x0 outer cache controller)
make dtbs
# 对于附加dtb到内核上去，可以用cat *.dtb >> zImage,生成的zImage可以直接用bootz启动
# 类似的，uImage+dtb则不行，要先生成附加了dtb的zImage->make uImage->uImage才可用
cat xxx.dtb >> arch/arm/boot/zImage
make uImage


#3 qemu initramsfs
busybox --> export CROSS_COMPILE=arm-linux-gnueabi- --> make defconfig (Build BusyBox as a static binary (no shared libs)) --> make -j4 --> make install
mkdir dev proc sys
sudo cp -a /dev/{null,console,tty,tty1,tty2,tty3,tty4} dev/
rm linuxrc
vim init
(
#!/bin/busybox sh         
mount -t proc none /proc  
mount -t sysfs none /sys  
exec /sbin/init
)
chmod a+x init

find . | cpio -o -H newc | gzip > ../initramsfs.gz
#sudo qemu-system-arm -M vexpress-a9 -m 512M -kernel ./arch/arm/boot/zImage  -initrd ./initramsfs -serial stdio -nographic -append 'console=ttyAMA0'
sudo qemu-system-arm  -M vexpress-a9 -m 512M -kernel ./zImage -initrd ./initramfs.gz  -append 'console=ttyAMA0' -nographic -dtb ./vexpress-v2p-ca9.dtb

#decompress initrd
xz -dc initrd.img | cpio -id
#compress initrd
find . | cpio -c -o | xz -9 --format=lzma > initrd.img
#lzma compress
tar cfv backup.tar.lzma dir --lzma


#qemu for x86 ubuntu-server-18.04.05
qemu-img create ubuntu18.04.05.img 20G
qemu-system-x86_64 --enable-kvm -m 2048 -smp 2 -boot order=d -hda ubuntu18.04.05.img -cdrom ubuntu-18.04.5-live-server-amd64.iso
qemu-system-x86_64 --enable-kvm -m 2048 -smp 2 \
	-netdev user,id=mynet0,hostfwd=tcp::8022-:22,hostfwd=tcp::8090-:80 \
	-device virtio-net-pci,netdev=mynet0 \
	-hda ubuntu18.04.05.img \
	-hdb delinux_rootfs_18.04.amd64.img
