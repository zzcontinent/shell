#!/bin/bash
if [ $1 == '-r' ];then
	sed -i 's/{udebug.*return\(.*\);}*/return\1;/g' $2
	sed -i '/udebug(\"+++ in *+++\\r\\n\");/d' $2
	sed -i '/udebug(\"--- out *---\\r\\n\");/d' $2
else
	sed -i '/^{/a\\tudebug(\"+++ in  +++\\r\\n");' $@
	sed -i 's/return\(.*\);/{udebug(\"--- out ---\\r\\n\");return\1;}/g' $@
	sed -i  '/^}$/i\\tudebug(\"--- out ---\\r\\n\");' $@
fi
