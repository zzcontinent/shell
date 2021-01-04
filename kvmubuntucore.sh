#!/bin/sh
kvm -smp 2 -m 1500 -netdev user,id=mynet0,hostfwd=tcp::8022-:22,hostfwd=tcp::8090-:80 -device virtio-net-pci,netdev=mynet0 -drive file=/home/cliff/data/software_pkg/ubuntu-core-18-amd64.img,format=raw
