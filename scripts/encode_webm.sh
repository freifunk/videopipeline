#!/usr/bin/env bash

# Single-pass VP8 with CRF (like h264's quality-based encoding).
# Tuned for 4-core workers: -threads 4, -cpu-used 2 for reasonable speed.
ffmpeg -y -analyzeduration 40000000 -probesize 100000000 -i "video.mp4" \
  -c:v libvpx -threads 4 -g 120 -b:v 0 -crf 33 \
  -deadline good -cpu-used 2 \
  -c:a libvorbis -b:a 96k -ac:a 2 -ar:a 48000 \
  -f webm -v 24 -y "${VIDEO_ID}-webm.webm"
