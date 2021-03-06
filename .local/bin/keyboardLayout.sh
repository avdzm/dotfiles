#!/usr/bin/bash

if [ $(setxkbmap -query | grep layout | awk '{print $2}') == "us" ]; then
  setxkbmap -layout el && notify-send --icon /usr/share/icons/Dracula/apps/scalable/key_bindings.svg "Keyboard Layout" "Keyboard set to Greek π¬π·" || notify-send --icon /usr/share/icons/Dracula/apps/scalable/key_bindings.svg "Keyboard Layout" "Something went wrong :/"
else
  setxkbmap -layout us && notify-send --icon /usr/share/icons/Dracula/apps/scalable/key_bindings.svg "Keyboard Layout" "Keyboard set to US πΊπΈ " || notify-send --icon /usr/share/icons/Dracula/apps/scalable/key_bindings.svg "Keyboard Layout" "Something went wrong :/"
fi
