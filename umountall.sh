#!/bin/sh
for f in $@
do
	echo "+++ umounting $f +++"
	umount $f
done
