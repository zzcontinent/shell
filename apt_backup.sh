#!/bin/bash

cur_dir=`pwd $(dirname $0)`
pkg_list_to_backup=`apt list --installed 2>/dev/null | grep '\[installed\]' | cut -d'/' -f1`
out_pkgs_dir=${cur_dir}/apt_backup_debs
pkg_list_to_backup_file=${cur_dir}/pkg_list_to_backup

process_cnt=4

func_download()
{
	cd $out_pkgs_dir
	i=0
	cnt=`cat $1 | wc -l`
	for pkg in `cat $1`
	do
		i=`expr $i + 1`
		depend_pkgs="$(apt depends $pkg 2>/dev/null | grep Depends | awk '{print $2}')"
		depend_pkgs_cnt="$(apt depends $pkg 2>/dev/null | grep Depends | awk '{print $2}' | wc -l)"
		j=0
		echo "[$i/${cnt}][$pkg]"
		apt download $pkg >/dev/null 2>&1
		echo "[$i/${cnt}][$pkg]" >> ${cur_dir}/process_done
		for x in $depend_pkgs
		do
			j=`expr $j + 1`
			echo "|- [$j/${depend_pkgs_cnt}][$x]"
			apt download $x >/dev/null 2>&1
			echo "|- [$j/${depend_pkgs_cnt}][$x]" >> ${cur_dir}/process_done
		done
	done
}

echo "$pkg_list_to_backup" > ${pkg_list_to_backup_file}
read -p "download pkg list in ${pkg_list_to_backup_file} -> ${out_pkgs_dir}, start download (process ${process_cnt}) now? type yes or no : "
[ "xyes" != "x${REPLY}" ] && exit 1

sleep 1

echo $out_pkgs_dir
[ ! -d $out_pkgs_dir ] && mkdir -p $out_pkgs_dir

split -n $process_cnt ${pkg_list_to_backup_file}
echo -n > ${cur_dir}/process_done
for x in `ls ${cur_dir}/xa*`
do
	func_download $x &
done

while true
do
	sleep 10
	echo "==> process_done :"
	cat ${cur_dir}/process_done
	[ `cat ${cur_dir}/process_done | wc -l` == 4 ] && echo "done!" && exit 0
done

rm ${cur_dir}/xa*
rm ${cur_dir}/process_done

