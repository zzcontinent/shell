#!/bin/sh
for f in $@
do
	mkdir -p $f.mount
	echo "+++ mounting $f +++"
	sudo mount $f $f.mount
done
