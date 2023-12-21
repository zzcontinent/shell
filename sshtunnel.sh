#!/bin/bash
[ $# != 3 ] &&  echo "sshtunnel.sh lport rport rip" && exit 1

ssh -N -L $1:0.0.0.0:$2 $3
