#!/bin/sh

# Set as a cron job to check for new RSS entries for newsboat.
# If newsboat is open, sends it an "R" key to refresh.

/usr/bin/notify-send "Updating RSS feeds..."

pgrep -f newsboat$ && /usr/bin/xdotool key --window "$(/usr/bin/xdotool search --name "newsboat")" R && exit

echo update > /tmp/newsupdate
pkill -RTMIN+6 "${STATUSBAR:-dwmblocks}"
/usr/bin/newsboat -x reload
rm -f /tmp/newsupdate
pkill -RTMIN+6 "${STATUSBAR:-dwmblocks}"
/usr/bin/notify-send " RSS feed update complete."
