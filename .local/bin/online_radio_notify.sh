#!/usr/bin/bash

#notify-send "Online Radio" "Playing \"$(echo $1 | awk -F:\  '{print $2}')\"" -i "$HOME/.config/awesome/themes/radio.yellow.png"
icon="$HOME/.config/awesome/themes/radio.yellow.png"

if [ $# -eq 1 ]; then
  notify-send "Online Radio" "$1" -i "$icon"
elif [ $# -eq 2 ]; then
  if [[ $1 == "Playing" ]]; then
    song="$(echo $2 | awk -F:\  '{print $2}')"
    if [ ${#song} -gt 0 ]; then
      notify-send "Online Radio" "$1 \"$song\"" -i "$icon"
    fi
  else
    notify-send "Online Radio" "$1 \"$2\"" -i "$icon"
  fi
elif [ $# -eq 3 ]; then
  notify-send "Online Radio" "$1 \"$2\" $3" -i "$icon"
fi
