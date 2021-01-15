#!/bin/bash
cp -av ./res/* /
systemctl enable dev_watch
systemctl restart dev_watch
