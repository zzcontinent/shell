#!/bin/bash
if [ $1 == '-r' ];then
	sed -i 's/{udebug.*return\(.*\);}*/return\1;/g' $2
	sed -i '/udebug(\"\\r\\n\");/d' $2
else
	sed -i '/^{/a\\tudebug(\"\\r\\n");' $@
	sed -i 's/return\(.*\);/{udebug(\"\\r\\n\");return\1;}/g' $@
fi
