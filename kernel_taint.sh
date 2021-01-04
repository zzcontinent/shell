#!/bin/sh
for i in $(seq 18); do echo $(($i-1)) $(($(cat /proc/sys/kernel/tainted)>>($i-1)&1));done

#  Table for decoding tainted state
#  Bit 	Log 	Number 	Reason that got the kernel tainted
#  0 	G/P 	1 	proprietary module was loaded
#  1 	_/F 	2 	module was force loaded
#  2 	_/S 	4 	SMP kernel oops on an officially SMP incapable processor
#  3 	_/R 	8 	module was force unloaded
#  4 	_/M 	16 	processor reported a Machine Check Exception (MCE)
#  5 	_/B 	32 	bad page referenced or some unexpected page flags
#  6 	_/U 	64 	taint requested by userspace application
#  7 	_/D 	128 	kernel died recently, i.e. there was an OOPS or BUG
#  8 	_/A 	256 	ACPI table overridden by user
#  9 	_/W 	512 	kernel issued warning
#  10 	_/C 	1024 	staging driver was loaded
#  11 	_/I 	2048 	workaround for bug in platform firmware applied
#  12 	_/O 	4096 	externally-built (“out-of-tree”) module was loaded
#  13 	_/E 	8192 	unsigned module was loaded
#  14 	_/L 	16384 	soft lockup occurred
#  15 	_/K 	32768 	kernel has been live patched
#  16 	_/X 	65536 	auxiliary taint, defined for and used by distros
#  17 	_/T 	131072 	kernel was built with the struct randomization plugin
