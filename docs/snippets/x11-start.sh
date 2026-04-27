#!/usr/bin/env bash
# x11-start.sh — Start termux-x11 with XFCE in one command
#
# Usage:
#   bash x11-start.sh [--dpi <value>] [--legacy] [--bgra]
#
# Options:
#   --dpi <value>   Override DPI (e.g. 120). Useful when fonts are too large.
#   --legacy        Pass -legacy-drawing (fix black-screen issue on some devices)
#   --bgra          Pass -force-bgra (fix swapped colours on some devices)

set -euo pipefail

DPI=""
EXTRA_ARGS=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dpi)     DPI="$2"; shift 2 ;;
    --legacy)  EXTRA_ARGS="$EXTRA_ARGS -legacy-drawing"; shift ;;
    --bgra)    EXTRA_ARGS="$EXTRA_ARGS -force-bgra"; shift ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [ -n "$DPI" ]; then
  EXTRA_ARGS="$EXTRA_ARGS -dpi $DPI"
fi

echo "Starting termux-x11 on display :1..."
# shellcheck disable=SC2086
exec termux-x11 :1 -xstartup "xfce4-session" $EXTRA_ARGS
