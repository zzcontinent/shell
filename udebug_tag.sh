#!/bin/bash
if [ $1 == '-r' ];then
	args=($@)
	unset args[0]
	sed -i '/^#include \"udebug.h\"/d' ${args[@]}
	sed -i 's/{udebug.*return \(.*\);}*/return \1;/g' ${args[@]}
	sed -i '/udebug(\"+++ in *+++\\r\\n\");/d' ${args[@]}
	sed -i '/udebug(\"--- out *---\\r\\n\");/d' ${args[@]}
else
	sed -i '1i#include \"udebug.h\"' $@
	sed -i '/^{/a\\tudebug(\"+++ in  +++\\r\\n");' $@
	sed -i 's/return \(.*\);/{udebug(\"--- out ---\\r\\n\");return \1;}/g' $@
	sed -i  '/^}$/i\\tudebug(\"--- out ---\\r\\n\");' $@
fi
