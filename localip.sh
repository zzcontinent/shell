#!/bin/bash
echo -n `ifconfig | grep 'inet\ ' | awk '{print $2}'`
