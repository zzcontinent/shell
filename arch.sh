# uefi
# efibootmgr --create --disk /dev/sdX --part Y --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=block_device_identifier resume=block_device_identifier rw initrd=\initramfs-linux.img'
# 
# install
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
# passwd

efibootmgr --create --disk /dev/sda --part 1 --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=/dev/sda3 resume=/dev/sda2 rw initrd=\initramfs-linux.img'
