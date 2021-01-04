#!/bin/bash

cur_dir=`pwd $(dirname $0)`
pkg_list_all=`apt list --installed 2>/dev/null | grep installed | cut -d'/' -f1`
out_pkgs_dir=${cur_dir}/backup_debs
echo $out_pkgs_dir
[ ! -d $out_pkgs_dir ] && mkdir -p $out_pkgs_dir
echo "$pkg_list_all" > ${cur_dir}/todo_list
process_cnt=4
split -n $process_cnt ${cur_dir}/todo_list

echo -n > ${cur_dir}/process_done
func_download()
{
        cd $out_pkgs_dir
        i=0
        cnt=`cat $1 | wc -l`
        for pkg in `cat $1`
        do
                i=`expr $i + 1`
                echo "pkg [$i/${cnt}] ==> $pkg"
                depend_pkgs="$(apt depends $pkg 2>/dev/null | grep Depends | awk '{print $2}')"
                depend_pkgs_cnt="$(apt depends $pkg 2>/dev/null | grep Depends | awk '{print $2}' | wc -l)"
                j=0
                apt download $pkg >/dev/null 2>&1
                for x in $depend_pkgs
                do 
                        j=`expr $j + 1`
                        echo "depend_pkgs: [$j/${depend_pkgs_cnt}] ==> $x"
                        apt download $x >/dev/null 2>&1
                done
        done
	echo $1 >> ${cur_dir}/process_done
}

sleep 1
for x in `ls ${cur_dir}/xa*`
do
        func_download $x &
done

while true
do
        sleep 10
	echo "==> process_done val:"
	cat ${cur_dir}/process_done
        [ `cat ${cur_dir}/process_done | wc -l` == 4 ] && echo "done!" && exit 0
done
