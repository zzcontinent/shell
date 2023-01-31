pkg_need_resintall=`apt list --upgradable 2>/dev/null | grep -v 'List*' | awk -F'/' '{print $1}'`
echo "need reinstall pkgs: ${pkg_need_resintall}"
[ -z ${pkg_need_resintall} ] && echo "no pkg need reinstall" && exit 0
sleep 1
sudo apt install --reinstall ${pkg_need_resintall}
