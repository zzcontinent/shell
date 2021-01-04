#!/bin/sh
sudo docker run --name slave02 -id --privileged=true --ip=172.17.0.4 ubuntu_master /sbin/init
