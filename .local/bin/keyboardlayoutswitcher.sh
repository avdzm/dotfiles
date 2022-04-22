#!/usr/bin/bash

numberofparameter=$#                                                # Gets the number of parameter passed
currentlayout=$(setxkbmap -query | grep layout | awk '{print $2}')  # Gets the current layout
langLayout=($*)                                                     # Passes the parameters into an array

i=0

while [[ "$i" -lt "$numberofparameter" ]]; do
  if [[ "${langLayout[$i]}" == "${currentlayout}" ]]; then
    break
  fi
  i=$(($i+1))
done

# checks if i has not reached to the last parameter (last language)
if [[ "$i" -lt "(($numberofparameter-1))" ]]; then
  # Sets to next parameter (next language)
  setxkbmap -layout ${langLayout[$(($i+1))]} && notify-send --icon /usr/share/icons/Dracula/apps/scalable/key_bindings.svg "Keyboard Layout" "Keyboard set to ${langLayout[$(($i+1))]}" || notify-send --icon /usr/share/icons/Dracula/apps/scalable/key_bindings.svg "Keyboard Layout" "Something went wrong :/"
else
  # Has reached the end, so looping back to the first parameter (first language)
  setxkbmap -layout $1 && notify-send --icon /usr/share/icons/Dracula/apps/scalable/key_bindings.svg "Keyboard Layout" "Keyboard set to $1" || notify-send --icon /usr/share/icons/Dracula/apps/scalable/key_bindings.svg "Keyboard Layout" "Something went wrong :/"
fi
