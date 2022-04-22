#!/usr/bin/bash

#Checks if audio is muted
if [ "$(pulsemixer --get-mute)" -eq 0 ]; then
  #Prints current volume icon and current volume percentage
  curVol=$(pulsemixer --get-volume | awk '{ print $1 }')
  icon=""
  if [ "$curVol" -ge 66 ]; then
    icon=""
  elif [ "$curVol" -lt 66 ] && [ "$curVol" -ge 33 ]; then
    icon="" 
  elif [ "$curVol" -lt 33 ]; then
    icon=""
  fi
  echo "$icon $curVol%"
elif [ "$(pulsemixer --get-mute)" -eq 1 ]; then
  #Prints muted icon only
  echo ""
fi
