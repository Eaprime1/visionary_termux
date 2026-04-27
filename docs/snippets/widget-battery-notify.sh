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

# Parse fields (jq preferred; fall back to sed if not installed)
if command -v jq > /dev/null 2>&1; then
  level=$(echo "$battery_json"   | jq -r '.percentage')
  status=$(echo "$battery_json"  | jq -r '.status')
  plugged=$(echo "$battery_json" | jq -r '.plugged')
  temp=$(echo "$battery_json"    | jq -r '.temperature')
else
  level=$(echo "$battery_json"   | sed -n 's/.*"percentage":[[:space:]]*\([0-9]*\).*/\1/p')
  status=$(echo "$battery_json"  | sed -n 's/.*"status":[[:space:]]*"\([^"]*\)".*/\1/p')
  plugged=$(echo "$battery_json" | sed -n 's/.*"plugged":[[:space:]]*"\([^"]*\)".*/\1/p')
  temp=$(echo "$battery_json"    | sed -n 's/.*"temperature":[[:space:]]*\([0-9.]*\).*/\1/p')
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
