qemu-system-aarch64 \
	-m 2048 -smp 2 -cpu cortex-a72 -M virt \
	-nographic -pflash flash0.img -pflash flash1.img \
	-drive if=none,file=rootfs.img2,id=hd0 \
	-device virtio-blk-device,drive=hd0 \
	-netdev user,id=user0,hostfwd=tcp::2223-:22 \
	-device virtio-net-device,netdev=user0 \
#	-enable-kvm -cpu host
