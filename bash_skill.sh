#/bin/bash

#执行前把命令展开并打印
set -x
#遇到命令失败(ret != 0)，立即退出
set -e 
cmd_xxx || true
set -e cmd1; set +e cmd2; set -e;
#set +e 暂时取消报错 ()
#使用未定义的变量立即退出
set -u
${var:-}
#管道中一个命令出错，立即退出
-o pipefail


#防止重复运行
flock --wait 5 -e 'lock_myscript' -c "bash myscript.sh"

exec 123<>lock_myscript #把lock_myscript打开为文件锁123
flock --wait 5 123 || { echo 'cannot get lock';exit 1; }

#意外退出时，杀掉所有子进程
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

#超时退出
timeout 600s cmd1 arg1 arg2

#1. # 号截取，删除左边字符，保留右边字符
echo ${var#*//}
#2. ## 号截取，删除左边字符，保留右边字符
echo ${var##*/}
#3. %号截取，删除右边字符，保留左边字符
echo ${var%/*}
#4. %号截取，删除右边字符，保留左边字符
echo ${var%%/*}
#5. 从左边第几个字符开始，及字符的个数
echo ${var:0:5}
#6. 从左边第几个字符开始，一直到结束。
echo ${var:7}
#7. 从右边第几个字符开始，及字符的个数
echo ${var:0-7:3}
#8. 从右边第几个字符开始，一直到结束。
echo ${var:0-7}
