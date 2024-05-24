#!/bin/sh
echo "mounting to /tmp/ramfs_workspace"
mkdir -p /tmp/ramfs_workspace
mount -t tmpfs tmpfs /tmp/ramfs_workspace


