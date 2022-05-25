#!/bin/bash
INPUNT=$(printf '%x' $1 | tr a-z A-Z)
printf "============%64s\n" $(echo "obase=2;ibase=16;8888888888888888"|bc)
printf "input (hex):%64s\n" $(echo "obase=16;ibase=16;${INPUNT}"|bc)
printf "output(bin):%64s\n" $(echo "obase=2;ibase=16;${INPUNT}"|bc)

