#!/bin/bash
INPUNT=$1
printf "============%64s\n" '|-60|-56|-52|-48|-44|-40|-36|-32|-28|-24|-20|-16|-12|--8|--4|--0'
printf "input (bin):%64s\n" $(echo "obase=2;ibase=2;${INPUNT}"|bc)
printf "============%64s\n" '|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'
printf "output(hex):%64s\n" $(echo "obase=16;ibase=2;${INPUNT}"|bc)
printf "============%64s\n" '|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'
printf "output(oct):%64s\n" $(echo "obase=8;ibase=2;${INPUNT}"|bc)
printf "============%64s\n" '|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---'
printf "output(dec):%64s\n" $(echo "obase=10;ibase=2;${INPUNT}"|bc)
