#!/bin/bash
pipe="|"
cmd0="-a"
cmd1="${cmd0}l"
cmd="ls ${cmd1} ${pipe} column -t"
echo ${cmd}
eval ${cmd}


temp1=$#
echo ${temp1}
eval echo \$$#


