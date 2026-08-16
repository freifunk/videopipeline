#!/usr/bin/env bash
# Legacy shell publisher. Prefer publish_videos_to_voctoweb.py (used by GoCD).
# Kept in sync for manual use: size in bytes, correct width/height, fail on HTTP errors.
set -euo pipefail

: "${VOCTOWEB_URL:?}"
: "${API_KEY:?}"
: "${ACRONYM:?}"
: "${LANGUAGE:?}"
: "${SLUG:?}"
: "${TITLE:?}"
: "${SUBTITLE:?}"
: "${DESCRIPTION:?}"
: "${PERSONS:?}"
: "${TAGS:?}"
: "${LINK:?}"
: "${DATE:?}"
: "${RELEASE_DATE:?}"
: "${VIDEO_ID:?}"

VOCTOWEB_URL="${VOCTOWEB_URL%/}"

VIDEO_LENGTH=$(ffprobe -loglevel quiet -print_format default -show_format video-h264.mp4 \
  | sed -n 's/^duration=\([0-9]*\).*/\1/p')
VIDEO_WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width \
  -of default=noprint_wrappers=1:nokey=1 video-h264.mp4)
VIDEO_HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height \
  -of default=noprint_wrappers=1:nokey=1 video-h264.mp4)
MP4_SIZE=$(stat -c '%s' video-h264.mp4)
WEBM_SIZE=$(stat -c '%s' video-webm.webm)

# Shell cannot easily send JSON arrays; persons/tags are space-separated strings.
# Use the Python script in production pipelines.
auth_hdr=( -H "Authorization: Token token=${API_KEY}" -H "Content-Type: application/json" )

curl --fail-with-body -sS "${auth_hdr[@]}" -d "{
   \"api_key\": \"${API_KEY}\",
    \"acronym\": \"${ACRONYM}\",
    \"event\":{
      \"poster_filename\": \"${ACRONYM}/${VIDEO_ID}/${VIDEO_ID}_preview.jpg\",
      \"thumb_filename\": \"${ACRONYM}/${VIDEO_ID}/${VIDEO_ID}_thumb.jpg\",
      \"timeline_filename\": \"${ACRONYM}/${VIDEO_ID}/${VIDEO_ID}.timeline.jpg\",
      \"thumbnails_filename\": \"${ACRONYM}/${VIDEO_ID}/${VIDEO_ID}.vtt\",
      \"guid\": \"${VIDEO_ID}\",
      \"original_language\": \"${LANGUAGE}\",
      \"slug\": \"${SLUG}\",
      \"title\": \"${TITLE}\",
      \"subtitle\": \"${SUBTITLE}\",
      \"description\": \"${DESCRIPTION}\",
      \"persons\": \"${PERSONS}\",
      \"tags\": \"${TAGS}\",
      \"link\": \"${LINK}\",
      \"date\": \"${DATE}\",
      \"release_date\": \"${RELEASE_DATE}\"
    }
  }" "${VOCTOWEB_URL}/api/events"

curl --fail-with-body -sS "${auth_hdr[@]}" -d "{
   \"api_key\": \"${API_KEY}\",
    \"guid\": \"${VIDEO_ID}\",
    \"recording\":{
      \"filename\": \"${VIDEO_ID}-h264.mp4\",
      \"folder\": \"${ACRONYM}/${VIDEO_ID}\",
      \"mime_type\": \"video/mp4\",
      \"language\": \"${LANGUAGE}\",
      \"size\": ${MP4_SIZE},
      \"length\": ${VIDEO_LENGTH},
      \"width\": ${VIDEO_WIDTH},
      \"height\": ${VIDEO_HEIGHT}
    }
  }" "${VOCTOWEB_URL}/api/recordings"

curl --fail-with-body -sS "${auth_hdr[@]}" -d "{
   \"api_key\": \"${API_KEY}\",
    \"guid\": \"${VIDEO_ID}\",
    \"recording\":{
      \"filename\": \"${VIDEO_ID}-webm.webm\",
      \"folder\": \"${ACRONYM}/${VIDEO_ID}\",
      \"mime_type\": \"video/webm\",
      \"language\": \"${LANGUAGE}\",
      \"size\": ${WEBM_SIZE},
      \"length\": ${VIDEO_LENGTH},
      \"width\": ${VIDEO_WIDTH},
      \"height\": ${VIDEO_HEIGHT}
    }
  }" "${VOCTOWEB_URL}/api/recordings"

echo "published ${VIDEO_ID}: mp4=${MP4_SIZE}B webm=${WEBM_SIZE}B ${VIDEO_WIDTH}x${VIDEO_HEIGHT} ${VIDEO_LENGTH}s"
