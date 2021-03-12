#!/bin/sh
sudo docker run --name slave01 -id --privileged=true --ip=172.17.0.3 ubuntu_master /sbin/init
