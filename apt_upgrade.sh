#!/bin/bash

pkg_list_upgrade="`apt list --upgradable 2>/dev/null | grep 'upgradable' | cut -d'/' -f1`"
echo "=======need upgrade: ${pkg_list_upgrade}"
[ -z ${pkg_list_upgrade} ] && exit 0

sleep 1
sudo apt upgrade -y

pkg_list_upgrade="`apt list --upgradable 2>/dev/null | grep 'upgradable' | cut -d'/' -f1`"
echo "=======need upgrade reinstall: ${pkg_list_upgrade}"
[ -z ${pkg_list_upgrade} ] && exit 0

sleep 1
sudo apt install --reinstall ${pkg_list_upgrade}
