#!/usr/bin/env bash
FORMAT=$1

if [ "$FORMAT" == "h264" ]; then
    EXT="mp4"
else
    EXT="webm"
fi

rsync -a ${VIDEO_ID}-${FORMAT}.${EXT} ${CDN_SERVER_USERNAME}@${CDN_ADDRESS}:${CDN_FILES_FOLDER}/${ACRONYM}/${VIDEO_ID}/
