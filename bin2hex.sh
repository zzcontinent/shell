#!/bin/bash
INPUNT=$1
printf "============%64s\n" '|-60|-56|-52|-48|-44|-40|-36|-32|-28|-24|-20|-16|-12|--8|--4|--0'
printf "============%64s\n" $(echo "obase=2;ibase=16;8888888888888888"|bc)
printf "input (bin):%64s\n" $(echo "obase=2;ibase=2;${INPUNT}"|bc)
printf "input (dec):%64s\n" $(echo "obase=10;ibase=2;${INPUNT}"|bc)
printf "output(hex):%64s\n" $(echo "obase=16;ibase=2;${INPUNT}"|bc)
