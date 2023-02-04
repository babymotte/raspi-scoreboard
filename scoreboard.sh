#!/bin/bash
sudo xinit -- -nocursor &
rm .config/chromium/Default/Preferences
DISPLAY=:0 chromium-browser --window-position=0,0 --window-size=1920,1080 --app="http://scoreboard.local/" --start-maximized --no-default-browser-check --start-fullscreen --kiosk --noerrdialogs --disable-translate --fast --fast-start --disable-features=TranslateUI --disk-cache-dir=/dev/null --password-store=basic
