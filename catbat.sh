#!/bin/sh

# Prints all batteries, to DWMBlocks 

case $BLOCK_BUTTON in
        3) notify-send "Bat Battery module" "Bat: discharging
NoChrg: not charging
Stag: stagnant charge
Charge: charging
Charged: charged
LowBat: battery very low!
- Scroll to change adjust xbacklight." ;;
        4) xbacklight -inc 10 ;;
        5) xbacklight -dec 10 ;;
        6) "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

# Loop through all attached batteries and format the info
for battery in /sys/class/power_supply/BAT?*; do
        # If non-first battery, print a space separator.
        [ -n "${capacity+x}" ] && printf " "
        # Sets up the status and capacity
        case "$(cat "$battery/status" 2>&1)" in
                "Full") status="charged" ;;
                "Discharging") status="discharge" ;;
                "Charging") status="pluggedin" ;;
                "Not charging") status="notcharging" ;;
                "Unknown") status="Ecomode/lowpower" ;;
                *) exit 1 ;;
        esac
        capacity="$(cat "$battery/capacity" 2>&1)"
        # Will make a warn variable if discharging and low
        [ "$status" = "notcharging" ] && [ "$capacity" -le 25 ] && warn="!"
        # Prints the info
        printf "%s%s%d%%" "$status" "$warn" "$capacity"; unset warn
done && printf "\\n"
