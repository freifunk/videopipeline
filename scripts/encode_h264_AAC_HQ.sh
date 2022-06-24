#!/usr/bin/env bash

SOURCE=$1
TARGET=$2
TITLE=$3

ffmpeg -v warning -i "${SOURCE}" -vf yadif \
  -c:v libx264 -pix_fmt yuv420p -crf:v 23 -profile:v high -level:v 4.2 \
  -b:a 128k -metadata title="'${TITLE}'" \
    -metadata album="<album>" \
    -metadata copyright="Licensed to the public under http://creativecommons.org/licenses/by-sa/3.0/" \
    -f mp4 -movflags faststart -v 24 -y "out.mp4"