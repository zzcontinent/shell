#!/bin/bash

if [ $# -eq 0 ];then
	echo "openwork.sh 1 ==> +++ open dirs +++"
	echo "openwork.sh 2 ==> +++ open pdfs +++"
	echo "openwork.sh 3 ==> +++ open chrome +++"
	exit 1
fi

if [ x"$1" = 'x1' ];then
	echo "+++ open dirs +++"
	working_dir=('/home/cliff/dgworkspace/FGLinux_HMV3/src/gitlab/FGLinux_HMV3'
		'/home/cliff/cworkspace/github/Tsinghua/ucore_os_lab'
		'/home/cliff/dgworkspace/FGLinux_HMV3/pub/DELinux'
		'/home/cliff/dgworkspace/FGLinux_HMV3/src'
	)

	for dir in ${working_dir[@]}
	do
		terminator --new-tab --working-directory=$dir &
	done
elif [ x"$1" == "x2" ];then
	echo "+++ open pdfs +++"
	pdfs=('/home/cliff/ucore_os_docs.pdf'
		'/home/cliff/data/wiki/linux/ARM上电启动及Uboot代码分析.pdf'
	)

	for pdf in ${pdfs[@]}
	do
		okular $pdf &
	done
elif [ x"$1" == "x3" ];then
	echo "+++ open chrome +++"
	chromium-browser &
fi
