#!/bin/bash

IN_DIR=$1
OUT_DEB=${IN_DIR}.deb
echo '+++ md5 +++'
pushd $IN_DIR
find -type f | grep -v './DEBIAN' | xargs md5sum > DEBIAN/md5sums
popd

echo '+++ pack +++'
dpkg -b $IN_DIR $OUT_DEB
