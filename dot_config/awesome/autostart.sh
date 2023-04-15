#!/bin/bash

#Kill Programs
killall picom ; picom -f &
killall dunst ; dunst &

#Window Manager
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
dualmonitor

#Mouse and Keyboard
#xsetroot -cursor_name left_ptr &
#xinput --set-prop 'Logitech Wireless Mouse PID:4022' 'libinput Accel Profile Enabled' 0 0 &
#xinput --set-prop 'Logitech Wireless Mouse PID:4022' 'Coordinate Transformation Matrix' 1.0 0 0 0 1.0 0 0 0 2 &
#setxkbmap br thinkpad

#Programs
pamac-tray
xfce4-power-manager
numlockx on
systemctl --user stop plasma-kglobalaccel.service
