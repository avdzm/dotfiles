#!/bin/bash

options="1: Span external screen to the LEFT\n2: Span external screen to the RIGHT\n3: Span external monitor to the TOP\n4: Mirror to the external monitor\n5: Use external monitor only\n6: Use laptop's monitor only"

selected=`echo -e "$options" | rofi -dmenu -i -p "Set Monitor" -lines 6 -location 2 -width 100 | cut -d ':' -f 1` 

case "$selected" in
  "") exit 0                                                                                                                                                                                           ;;
  1)xrandr --output eDP --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off ;;
  2)xrandr --output eDP --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off ;;
  3)xrandr --output eDP --primary --mode 1920x1080 --pos 0x1080 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off ;;
  4)xrandr --output eDP --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off    ;;
  5)xrandr --output eDP --off --output HDMI-A-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off                                         ;;
  6)xrandr --output eDP --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --off --output DisplayPort-0 --off --output DisplayPort-1 --off                                         ;;
  *) exit 0                                                                                                                                                                                            ;;
esac
