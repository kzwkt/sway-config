#!/bin/bash

### Copyright (C) 2022 Vinni Richburgh
#
# This script is to be called from ~/.config/sway/config.
# In case of an error (or two) check,
#       -if all the files written to by this script exist already (If in doubt, run this script once from within your favourite terminal emulator.)
#       -if you've baked "Device Drivers ---> Hardware Monitoring Support ---> AMD Family 10h+ temperature sensor" and so on into your kernel. (No idea abou
t Intel, but I'm sure you'll find a way;))
#       -if this script is set to be executable
#       -if your pc is plugged in and turned on
#
# This script will be subject to change in the near future, where I'll fix some inconveniences like up- and downstream only being displayed in bytes per sec
ond. (ugly af)
#
# Have fun ricing the sh1t out of your sway-wm and consider visiting vinni-richburgh.com (I'm making games.)
#


# Gets date and time, nothing special
date=$(date +'%Y-%m-%d | %l:%M:%S %p')

# Gets the number of bytes received/sent, calculates their delta and adds some padding, so you don't get a seizure from looking at your swaybar.
rx_delta=$(($(cat /sys/class/net/enp40s0/statistics/rx_bytes) - $(cat ~/.config/sway/status/.rx_bytes)))B/s
rx_delta=$(printf "%8s" $rx_delta)
cp -f /sys/class/net/enp40s0/statistics/rx_bytes ~/.config/sway/status/.rx_bytes

tx_delta=$(($(cat /sys/class/net/enp40s0/statistics/tx_bytes) - $(cat ~/.config/sway/status/.tx_bytes)))B/s
tx_delta=$(printf "%8s" $rx_delta)
cp -f /sys/class/net/enp40s0/statistics/tx_bytes ~/.config/sway/status/.tx_bytes

# Gets the ram usage and formats it a bit. (also padding)
ram_total=$(free -h --si | awk 'NR==2 {print $2}')
ram_used=$(free -h --si | awk 'NR==2 {print $3}')
ram_percent=$(free | awk 'NR==2 {printf "%.1f", $3*100/$2}')
ram_percent=$(printf "%5s" $ram_percent)%
ram_pretty=$ram_percent\ \($ram_used\ /\ $ram_total\)

# Gets the raw cpu temperature data and makes it readable by adding a .
cpu_temp=$(cat /sys/devices/pci0000\:00/0000\:00\:18.3/hwmon/hwmon1/temp1_input)
cpu_temp=${cpu_temp::-3}.${cpu_temp:2:-2}°C

# Calculates cpu usage.
cpu_active=$(($(cat /proc/stat | awk 'NR==1 {print $2+$4+$6}')-$(cat ~/.config/sway/status/.stat | awk 'NR==1 {print $2+$4+$6}')))
cpu_idle=$(($(cat /proc/stat | awk 'NR==1 {print $5}')-$(cat ~/.config/sway/status/.stat | awk 'NR==1 {print $5}')))
cpu_usage=$(echo "$cpu_active $cpu_idle" | awk '{printf "%.1f", $1*100/($1+$2)}')
cpu_usage=$(printf "%5s" $cpu_usage)%
cp -f /proc/stat ~/.config/sway/status/.stat


#
# Here's some more ideas on what you could add to your fancy, minimalist swaybar:
#
#kernel_flex=$(uname -r)        # prints out the name of your own special custom kernel
#whoiam=$(whoami)               # prints your user name, so you don't forget who you are


# feeds the results from above to swaybar
echo "| $cpu_usage & $cpu_temp | $ram_pretty | $rx_delta & $tx_delta | $date "
