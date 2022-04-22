#!/usr/bin/bash
#grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END { printf(" %-.2f",usage); print "%"}'
#

awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else printf(" %-.1f%%",($2+$4-u1) * 100 / (t-t1)); }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat)
