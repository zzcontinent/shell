#!/bin/bash
echo -n `curl ip4.me 2>/dev/null` | sed 's/.*>\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/g'
