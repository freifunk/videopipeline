#!/bin/bash

FORMAT = $1

ffmpeg -i "$video_id-processed.mp4"   \
  -map_metadata 0 \
  -metadata:s:a:0 LICENSE="Licensed to the public under https://creativecommons.org/licenses/by/2.0/de/ - http://media.freifunk.net" \
  -c:a copy -v 24 -y "$video_id-${FORMAT}.mp4"