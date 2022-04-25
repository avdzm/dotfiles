#!/usr/bin/bash

# Sets wallpaper
feh --randomize /home/avdzm/Pictures/Wallpapers/alternate/ --bg-fill &

# Starts processes if they aren't already running 
if [ $(pgrep -c "slstatus") -eq 0 ]; then slstatus & fi
if [ $(pgrep -c "dunst") -eq 0 ]; then dunst & fi
if [ $(pgrep -c "compton") -eq 0 ]; then compton & fi
if [ $(pgrep -c "nm-applet") -eq 0 ]; then nm-applet & fi
if [ $(pgrep -c "diodon") -eq 0 ]; then diodon & fi
#if [ $(pgrep -c "clipit") -eq 0 ]; then clipit & fi
if [ $(pgrep -c "riseup-vpn") -eq 0 ]; then riseup-vpn.launcher  --start-vpn on & fi
if [ $(pgrep -c "kdeconnect-indicator") -eq 0 ]; then kdeconnect-indicator & fi
#if [ $(pgrep -c "xfce-power-manager") -eq 0 ]; then xfce-power-manager & fi
if [ $(pgrep -c "blueman-applet") -eq 0 ]; then blueman-applet & fi
if [ $(pgrep -c "unclutter-classic") -eq 0 ]; then unclutter-classic & fi
if [ $(pgrep -c "lxpolkit") -eq 0 ]; then lxpolkit & fi
if [ $(pgrep -c "redshift") -eq 0 ]; then redshift & else redshift -x & brightnessctl s 255 & fi
numlockx on &
