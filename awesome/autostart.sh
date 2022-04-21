#!/usr/bin/bash

if [ $(pgrep -c "compton") -eq 0 ]; then compton --config ~/.config/picom/picom3.conf & fi
#if [ $(pgrep -c "picom") -eq 0 ]; then picom --config ~/.config/picom/picom.conf & fi
if [ $(pgrep -c "nm-applet") -eq 0 ]; then nm-applet & fi
#if [ $(pgrep -c "clipit") -eq 0 ]; then clipit & fi
if [ $(pgrep -c "diodon") -eq 0 ]; then diodon & fi
#if [ $(pgrep -c "riseup-vpn") -eq 0 ]; then riseup-vpn.launcher  --start-vpn on & fi
if [ $(pgrep -c "riseup-vpn") -eq 0 ]; then snap run riseup-vpn.launcher --start-vpn on & fi
if [ $(pgrep -c "kdeconnect-indicator") -eq 0 ]; then kdeconnect-indicator & fi
#if [ $(pgrep -c "xfce-power-manager") -eq 0 ]; then xfce-power-manager & fi
if [ $(pgrep -c "mate-power-manager") -eq 0 ]; then mate-power-manager & fi
if [ $(pgrep -c "blueman-applet") -eq 0 ]; then blueman-applet & fi
if [ $(pgrep -c "unclutter-classic") -eq 0 ]; then unclutter-classic & fi
if [ $(pgrep -c "lxpolkit") -eq 0 ]; then lxpolkit & fi
if [ $(pgrep -c "redshift") -eq 0 ]; then redshift & else redshift -x & brightnessctl s 255 & fi
numlockx on &
