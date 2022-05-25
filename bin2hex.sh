#!/bin/bash
INPUNT=$1
printf "============%64s\n" $(echo "obase=2;ibase=16;8888888888888888"|bc)
printf "input (bin):%64s\n" $(echo "obase=2;ibase=2;${INPUNT}"|bc)
printf "output(hex):%64s\n" $(echo "obase=16;ibase=2;${INPUNT}"|bc)
