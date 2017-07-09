# sabnzbd speed limiter

Limits the download speed of SABNZBD when a particular device is present on your local network. I use this to throttle downloads when my phone is detected, so that SABNZBD doesn't swallow up all the download bandwidth while I'm at home.

This uses ARP to check whether the device is on the local network, which is a simple but not very reliable method as the target device's ARP entry may very well not be cached on the computer running this script. Your mileage will vary.

## Usage

1. Run `$ cp .env.example .env` and fill in/change the variables as required
1. Run `$ bash set-limit.sh`

## Mac OS - starting the daemon on system login

1. Edit the `com.alexplescan.sabnzbd-limiter.plist.example` file to include the correct path to the executable file on your machine
1. `$ cp com.alexplescan.sabnzbd-limiter.plist.example ~/Library/LaunchAgents/com.alexplescan.sabnzbd-limiter.plist`
1. `launchctl load com.alexplescan.sabnzbd-limiter.plist`