# sway-config

In this repo you'll find...

- my sway config (based on the one you get out of the box, just saying)

- a script to display some useful information via swaybar (since waybar gets all the love and no one seems to care about swaybar)

- some temporary files that are required to calculate the differences of certain values over time (e.g. .config/sway/status/.rx_bytes)

.config/sway/status/status.sh IS NOT GUARANTEED TO WORK OUT OF THE BOX!
There's AMD drivers involved in extracting the current cpu temperature. (For more details have a look at .config/sway/status/status.sh)
Owners of e.g. an Intel cpu will have to do their own research on how to read from their thermal sensors.

There's (without the setup script that's coming soon) also the need to change the network interface name from eth0 to whatever yours is called. Type ifconfig into your terminal emulator of choice to find it.

Have a nice one!
