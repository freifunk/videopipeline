#!/bin/bash

FILE=$1

timelens "$FILE" \
  --timeline "$VIDEO_ID.timeline.jpg"\
  --thumbnails "$VIDEO_ID.vtt"