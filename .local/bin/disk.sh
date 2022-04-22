#!/usr/bin/bash
df -h | grep /dev/$1 | awk '{print $4}' | xargs echo ""
