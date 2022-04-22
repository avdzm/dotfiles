#!/usr/bin/bash

#Pings gnu.org, succesfull will echo online, unsuccesfull will echo offline
ping -c 2 gnu.org &>/dev/null && echo "" || echo ""
