# MacWirelessMonitor
A bash shell script to keep scanning all wireless APs, showing AP's MAC, SSID, signal, channel. 

# Usage
Run in Mac terminal

macOS version, tested in 10.13.5

Admin is needed, following command will be called, sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport

Useful in corporate environment in which multiple APs are with same SSID, regardless which AP connected, all adjacent AP's Mac address will be shown with SSID, signal, channel. The AP currently connected will also be shown. APs are sorted as signal strength from strong to weak.

One SSID name could be as command line input to show only interested SSID.

Nice looking with colored text in output

# Screenshot
