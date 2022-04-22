#!/usr/bin/bash

#Uses the brightnessclt 
current="$(brightnessctl get)" #Gets the current value of the brightness
max="$(brightnessctl max)"    #Gets the maximum value
percentage=`echo "scale=1;$current/$max*100" | bc` #Calculates the percentage value

echo $percentage | awk '{ printf("%.0f\%", $0) }' | xargs echo ""

#
