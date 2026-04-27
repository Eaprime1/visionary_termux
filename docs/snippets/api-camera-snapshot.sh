#!/usr/bin/env bash
# api-camera-snapshot.sh — Take a timestamped photo using termux-api
#
# Prerequisites:
#   pkg install termux-api
#   Install the Termux:API Android app from F-Droid
#
# Usage:
#   bash api-camera-snapshot.sh [--camera <id>] [--output-dir <path>]
#
# Options:
#   --camera <id>        Camera ID: 0 = back, 1 = front (default: 0)
#   --output-dir <path>  Where to save photos (default: ~/storage/pictures/snapshots)

set -euo pipefail

CAMERA_ID=0
OUTPUT_DIR="${HOME}/storage/pictures/snapshots"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --camera)
      if [[ $# -lt 2 || "$2" == --* ]]; then
        echo "Missing value for --camera" >&2
        exit 1
      fi
      if ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "Invalid camera ID: $2" >&2
        exit 1
      fi
      CAMERA_ID="$2"
      shift 2
      ;;
    --output-dir)
      if [[ $# -lt 2 || "$2" == --* ]]; then
        echo "Missing value for --output-dir" >&2
        exit 1
      fi
      OUTPUT_DIR="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
OUTPUT_FILE="${OUTPUT_DIR}/snapshot_${TIMESTAMP}.jpg"

echo "Taking photo with camera $CAMERA_ID..."
termux-camera-photo -c "$CAMERA_ID" "$OUTPUT_FILE"

echo "Saved: $OUTPUT_FILE"

# Post an Android notification so you know it worked
termux-notification \
  --title "Snapshot saved" \
  --content "$OUTPUT_FILE" \
  --id snapshot_done
