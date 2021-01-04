sudo qemu-system-arm  -M vexpress-a9 -m 512M -kernel ./zImage -initrd ./initramfs.gz  -append 'console=ttyAMA0' -nographic -dtb ./vexpress-v2p-ca9.dtb
