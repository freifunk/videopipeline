#!/usr/bin/env bash

# ffmpeg -v warning -i "$video_id.mp4" -vf yadif \
#   -c:v libx264 -pix_fmt yuv420p -crf:v 23 -profile:v high -level:v 4.2 \
#    -c:a libfdk_aac -b:a 128k -metadata title="$title" \
#     -metadata album="<album>" \
#     -metadata copyright="Licensed to the public under http://creativecommons.org/licenses/by-sa/3.0/" \
#     -f mp4 -movflags faststart -v 24 -y "video_id.mp4"


ffmpeg -v warning -i "video.mp4" -vf yadif \
  -c:v libx264 -pix_fmt yuv420p -crf:v 23 -profile:v high -level:v 4.2 \
  -b:a 128k -metadata title="${title}" \
    -metadata album="<album>" \
    -metadata copyright="Licensed to the public under http://creativecommons.org/licenses/by-sa/3.0/" \
    -f mp4 -movflags faststart -v 24 -y "${VIDEO_ID}-h264.mp4"