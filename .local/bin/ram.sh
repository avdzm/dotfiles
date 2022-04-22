#!/usr/bin/bash
free -m | grep "Mem:" | awk '{printf("%.1f%%", ($3/$2)*100)}' | xargs echo ""
