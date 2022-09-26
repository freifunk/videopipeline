#!/usr/bin/env bash

# VOCTOWEB_URL="http://52.66.255.140:3000"
# API_KEY="6d72a1de-f38d-416c-bcaa-b9612de24d74"
# ACRONYM="freifunk"
# LANGUAGE="eng"
# SLUG="freifunk-2022"
# TITLE="Test title"
# SUBTITLE="Test subtitle"
# DESCRIPTION="Test Description"
# PERSONS="vijay andi"
# TAGS="test video pipeline"
# LINK="https://github.com/freifunk/videopipeline"
# DATE="2022-09-26"
# RELEASE_DATE="2022-09-26"
# VIDEO_ID="dd3456dd-e277-4947-95db-3b7c64d4216f"




VIDEO_LENGTH=$(ffprobe -loglevel quiet -print_format default -show_format video-h264.mp4 | grep duration= | sed -e 's/duration=\([[:digit:]]*\).*/\1/g')
VIDEO_WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 video-h264.mp4)
VIDEO_HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 video-h264.mp4)
MP4_SIZE=$(( $( stat -c '%s' video-h264.mp4) / 1024 / 1024 )) 
WEBM_SIZE=$(( $( stat -c '%s' video-webm.webm) / 1024 / 1024 )) 

curl -o /dev/null -s -H  "CONTENT-TYPE: application/json" -d '{
   "api_key":'"\"${API_KEY}\""',
    "acronym":'"\"${ACRONYM}\""',
    "event":{
      "poster_filename":'"\"${ACRONYM}/${VIDEO_ID}/${VIDEO_ID}_preview.jpg\""',
      "thumb_filename":'"\"${ACRONYM}/${VIDEO_ID}/${VIDEO_ID}_thumb.jpg\""',
      "timeline_filename":'"\"${ACRONYM}/${VIDEO_ID}/${VIDEO_ID}.timeline.jpg\""',
      "thumbnails_filename":'"\"${ACRONYM}/${VIDEO_ID}/${VIDEO_ID}.vtt\""',
      "guid":'"\"${VIDEO_ID}\""',
      "original_language":'"\"${LANGUAGE}\""',
      "slug":'"\"${SLUG}\""',
      "title":'"\"${TITLE}\""',
      "subtitle":'"\"${SUBTITLE}\""',
      "description":'"\"${DESCRIPTION}\""',
      "persons":'"\"${PERSONS}\""',
      "tags":'"\"${TAGS}\""',
      "link":'"\"${LINK}\""',
      "date":'"\"${DATE}\""',
      "release_date":'"\"${RELEASE_DATE}\""'
    }
  }' "${VOCTOWEB_URL}/api/events"


curl -o /dev/null -s -H  "CONTENT-TYPE: application/json" -d '{
   "api_key":'\"${API_KEY}\"',
    "guid":'\"${VIDEO_ID}\"',
    "recording":{
      "filename":'\"${VIDEO_ID}-h264.mp4\"',
      "folder":'\"${ACRONYM}/${VIDEO_ID}\"',
      "mime_type":'\"video/mp4\"',
      "language":'\"${LANGUAGE}\"',
      "size":'\"${MP4_SIZE}\"',
      "length":'\"${VIDEO_LENGTH}\"',
      "width":'\"${VIDEO_HEIGHT}\"',
      "height":'\"${VIDEO_WIDTH}\"'
    }
  }' "${VOCTOWEB_URL}/api/recordings"


curl -o /dev/null -s -H  "CONTENT-TYPE: application/json" -d '{
   "api_key":'\"${API_KEY}\"',
    "guid":'\"${VIDEO_ID}\"',
    "recording":{
      "filename":'\"${VIDEO_ID}-webm.webm\"',
      "folder":'\"${ACRONYM}/${VIDEO_ID}\"',
      "mime_type":'\"video/webm\"',
      "language":'\"${LANGUAGE}\"',
      "size":'\"${WEBM_SIZE}\"',
      "length":'\"${VIDEO_LENGTH}\"',
      "width":'\"${VIDEO_HEIGHT}\"',
      "height":'\"${VIDEO_WIDTH}\"'
    }
  }' "${VOCTOWEB_URL}/api/recordings"