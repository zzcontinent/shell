#!/bin/bash
INPUNT=$(printf '%x' $1 | tr a-z A-Z)
echo '-----------------------------------------------------------------------------'
printf "input (hex):%64s\n" $(echo "obase=16;ibase=16;${INPUNT}"|bc)
printf "input (dec):%64s\n" $(echo "obase=10;ibase=16;${INPUNT}"|bc)
echo '-----------------------------------------------------------------------------'
printf "            %64s\n" '|-60|-56|-52|-48|-44|-40|-36|-32|-28|-24|-20|-16|-12|--8|--4|--0'
printf "output(bin):%64s\n" $(echo "obase=2;ibase=16;${INPUNT}"|bc)
echo '-----------------------------------------------------------------------------'

