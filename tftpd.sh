#!/bin/bash

TFTPD_CONF="
# /etc/default/tftpd-hpa

TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/home/cliff/data/tftpd"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="--secure""
echo "${TFTPD_CONF}" > /etc/default/tftpd-hpa &&
service tftpd-hpa restart
