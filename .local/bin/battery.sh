#!/usr/bin/bash
state=$(upower -i $(upower -e | grep 'BAT') | grep -E "state" | awk '{print $NF}')
percentage=$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | awk '{print $NF}' | sed 's/%//')

# Sets icon
if [ $percentage -ge 80 ]; then
  icon=""
elif [ $percentage -ge 60 ] && [ $percentage -le 79 ]; then
  icon=""
elif [ $percentage -ge 40 ] && [ $percentage -le 59 ]; then
  icon=""
elif [ $percentage -ge 20 ] && [ $percentage -le 39 ]; then
  icon=""
elif [ $percentage -ge 0 ]  && [ $percentage -le 19 ]; then
  icon=""
  if [ $percentage -le 10 ] && [ $state ="discharging" ]; then
    systemctl poweroff
  fi
fi

if [ $state = "fully-charged" ]; then 
  echo "$icon o$percentage%";
elif [ $state = "discharging" ]; then
  echo "$icon -$percentage%";
elif [ $state = "charging" ]; then
  echo "$icon +$percentage%";
fi

# Sends notification when battery is low
if [ $percentage -lt 15 ] && [ $state = "discharging" ]; then
  notify-send "Huston, we have a problem." "Battery is extremly low :/" -u critical -i $HOME/.config/awesome/awesome-wm-widgets/battery-widget/spaceman.jpg
fi
