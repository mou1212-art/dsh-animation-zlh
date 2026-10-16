#!/usr/bin/env bash
#
# Preview the zlh_intro DSH boot animation.
# Author : caijingyan
# Repo   : dsh-animation-zlh
#
# Usage:
#   ./showanimation.sh            # play for 10 seconds (default)
#   ./showanimation.sh <seconds>  # play for N seconds
#   ./showanimation.sh full       # play the whole clip once
#
# Requires: ffplay (part of ffmpeg) or mpv/vlc as fallback.

set -u

VIDEO="zlh_intro/zlh_intro.mp4"

if [ ! -f "$VIDEO" ]; then
  echo "error: $VIDEO not found. Run this script from the repository root."
  exit 1
fi

ARG="${1:-10}"

if [ "$ARG" = "full" ]; then
  DURATION_ARGS=()
else
  case "$ARG" in
    ''|*[!0-9]*) echo "error: duration must be a number of seconds or 'full'"; exit 1 ;;
  esac
  DURATION_ARGS=(-t "$ARG")
fi

if command -v ffplay >/dev/null 2>&1; then
  echo "Playing $VIDEO with ffplay..."
  exec ffplay -hide_banner -loglevel error -autoexit "${DURATION_ARGS[@]}" "$VIDEO"
elif command -v mpv >/dev/null 2>&1; then
  echo "Playing $VIDEO with mpv..."
  exec mpv --really-quiet "$VIDEO"
elif command -v vlc >/dev/null 2>&1; then
  echo "Playing $VIDEO with vlc..."
  exec vlc --play-and-exit "$VIDEO"
else
  echo "error: no player found. Install ffmpeg (ffplay), mpv, or vlc."
  exit 1
fi
