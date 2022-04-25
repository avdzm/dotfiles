#!/usr/bin/bash

while true; do
  echo $(pgrep -c surf)
  if [ "$(pgrep -c surf)" -lt "2" ]; then
    tabbed surf localhost/darFarmsCattle -e
  fi
  #sleep 30
done
