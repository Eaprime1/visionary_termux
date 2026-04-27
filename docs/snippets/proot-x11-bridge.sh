#!/usr/bin/env bash
# proot-x11-bridge.sh — Launch a desktop environment inside proot-distro with X11
#
# Starts termux-x11 in the background (Termux host), then logs into a proot-distro
# and launches an XFCE session that renders on the host X11 display.
#
# Prerequisites:
#   pkg install termux-x11-nightly proot-distro xfce4
#   proot-distro install ubuntu   (or your preferred distro)
#
# Usage:
#   bash proot-x11-bridge.sh [--distro <name>] [--de <session-command>]
#
# Options:
#   --distro <name>    proot-distro name (default: ubuntu)
#   --de <command>     Desktop environment start command (default: xfce4-session)

set -euo pipefail

DISTRO="ubuntu"
DE_CMD="xfce4-session"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --distro) DISTRO="$2"; shift 2 ;;
    --de)     DE_CMD="$2"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# Start termux-x11 in the background if not already running
if ! pgrep -x termux-x11 > /dev/null 2>&1; then
  echo "Starting termux-x11 on display :1..."
  termux-x11 :1 &
  sleep 2
else
  echo "termux-x11 already running."
fi

echo "Entering proot-distro ($DISTRO) and starting $DE_CMD..."
# --shared-tmp shares /tmp between Termux and the container so the X11 socket is accessible
proot-distro login "$DISTRO" --shared-tmp -- \
  env DISPLAY=:1 DBUS_SESSION_BUS_ADDRESS="" "$DE_CMD"
