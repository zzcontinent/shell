#!/bin/bash

pkg_list_upgrade=`apt list --upgradable 2>/dev/null | grep 'upgradable' | cut -d'/' -f1`
echo ${pkg_list_upgrade}
sudo apt upgrade -y
pkg_list_upgrade=`apt list --upgradable 2>/dev/null | grep 'upgradable' | cut -d'/' -f1`
echo ${pkg_list_upgrade}

sudo apt install --reinstall ${pkg_list_upgrade}
