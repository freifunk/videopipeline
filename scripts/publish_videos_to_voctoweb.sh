#!/usr/bin/env bash

VIDEO_LENGTH=$(ffprobe -loglevel quiet -print_format default -show_format video.mp4 | grep duration= | sed -e 's/duration=\([[:digit:]]*\).*/\1/g')
VIDEO_WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 video.mp4)
VIDEO_HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 video.mp4)
MP4_SIZE=$(( $( stat -c '%s' ${VIDEO_ID}-h264.mp4) / 1024 / 1024 )) 
WEBM_SIZE=$(( $( stat -c '%s' ${VIDEO_ID}-webm.webm) / 1024 / 1024 )) 

curl -H "CONTENT-TYPE: application/json" -d '{
   "api_key":'${API_KEY}',
    "acronym":'${ACRONYM}',
    "event":{
      "guid":'${VIDEO_ID}',
      "original_language":'${LANGUAGE}',
      "slug":'${SLUG}',
      "title":'${TITLE}',
      "subtitle":'${SUBTITLE}',
      "description":'${DESCRIPTION}',
      "persons":'${PERSONS}',
      "tags":'${TAGS}',
      "link":'${LINK}',
      "date":'${DATE}',
      "release_date":'${RELEASE_DATE}',
      "poster_url":'${ACRONYM}/${VIDEO_ID}/${VIDEO_ID}_preview.jpg',
      "thumb_url":'${ACRONYM}/${VIDEO_ID}/${VIDEO_ID}_thumb.jpg',
      "timeline_url":'${ACRONYM}/${VIDEO_ID}/${VIDEO_ID}.timeline.jpg',
      "thumbnails_url":'${ACRONYM}/${VIDEO_ID}/${VIDEO_ID}.vtt'
    }
  }' "${VOCTOWEB_URL}/api/events"


curl -H "CONTENT-TYPE: application/json" -d '{
    
   "api_key":'${API_KEY}',
    "guid":'${VIDEO_ID}',
    "recording":{
      "filename":'${VIDEO_ID}-h264.mp4',
      "folder":'${ACRONYM}/${VIDEO_ID}',
      "mime_type":"video/mp4",
      "language":'${LANGUAGE}',
      "size":'${MP4_SIZE}',
      "length":'${VIDEO_LENGTH}',
      "width":'${VIDEO_HEIGHT}',
      "height":'${VIDEO_WIDTH}'
    }
  }' "${VOCTOWEB_URL}/api/recordings"


curl -H "CONTENT-TYPE: application/json" -d '{
    
   "api_key":'${API_KEY}',
    "guid":'${VIDEO_ID}',
    "recording":{
      "filename":'${VIDEO_ID}-webm.webm',
      "folder":'${ACRONYM}/${VIDEO_ID}',
      "mime_type":"video/webm",
      "language":'${LANGUAGE}',
      "size":'${WEBM_SIZE}',
      "length":'${VIDEO_LENGTH}',
      "width":'${VIDEO_HEIGHT}',
      "height":'${VIDEO_WIDTH}'
    }
  }' "${VOCTOWEB_URL}/api/recordings"

