#!/usr/bin/env bash
# widget-battery-notify.sh — Home-screen widget: post battery status as notification
#
# Place this script in ~/.shortcuts/ to make it a termux-widget home-screen shortcut.
# Tapping the widget reads battery state and posts an Android notification.
#
# Prerequisites:
#   pkg install termux-api
#   Install Termux:API and Termux:Widget Android apps from F-Droid
#   mkdir -p ~/.shortcuts && cp widget-battery-notify.sh ~/.shortcuts/battery.sh
#   Add a Termux:Widget to your home screen and select "battery.sh"

set -euo pipefail

# Read battery info as JSON
battery_json=$(termux-battery-status)

# Parse fields (jq preferred; fall back to grep+sed if not installed)
if command -v jq > /dev/null 2>&1; then
  level=$(echo "$battery_json"   | jq -r '.percentage')
  status=$(echo "$battery_json"  | jq -r '.status')
  plugged=$(echo "$battery_json" | jq -r '.plugged')
  temp=$(echo "$battery_json"    | jq -r '.temperature')
else
  level=$(echo "$battery_json"   | grep -o '"percentage":[0-9]*' | grep -o '[0-9]*')
  status=$(echo "$battery_json"  | grep -o '"status":"[^"]*"'    | cut -d'"' -f4)
  plugged=$(echo "$battery_json" | grep -o '"plugged":"[^"]*"'   | cut -d'"' -f4)
  temp=$(echo "$battery_json"    | grep -o '"temperature":[0-9.]*' | cut -d: -f2)
fi

# Build notification content
title="Battery: ${level}%"
content="${status}"
[ "$plugged" != "UNPLUGGED" ] && content="${content} — ${plugged}"
[ -n "$temp" ]                && content="${content} — ${temp}°C"

termux-notification \
  --title "$title" \
  --content "$content" \
  --id battery_widget \
  --priority default
