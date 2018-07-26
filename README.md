# MacWirelessMonitor
A bash shell script to keep scanning all wireless APs, showing AP's MAC, SSID, signal, channel. 

# Usage
Run in Mac terminal

macOS version, tested in 10.13.5

Following command will be called, 
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport

Useful in corporate environment in which multiple APs are broadcasting with same SSID, regardless which AP connected, all adjacent AP's Mac address will be shown with SSID, signal, channel. The AP currently connected will also be shown. APs are sorted as signal strength from strong to weak so to locate the closest AP.

One SSID name could be as command line input to show only interested SSID. SSID filter could be updated when running.

Nice looking with colored text in output

# Screenshot
![Screen Shot](https://github.com/brucehuang0907/MacWirelessMonitor/blob/master/ScreenShot.png)
