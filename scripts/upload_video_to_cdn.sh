#!/usr/bin/env bash
FORMAT=$1

if [ "$FORMAT" == "h264" ]; then
    EXT="mp4"
else
    EXT="webm"
fi

rsync -4 -a --rsync-path="mkdir -p ${CDN_FILES_FOLDER}/${ACRONYM}/${VIDEO_ID}/ && rsync" ${VIDEO_ID}-${FORMAT}.${EXT} ${CDN_ADDRESS}:/${CDN_FILES_FOLDER}/${ACRONYM}/${VIDEO_ID}/

mv ${VIDEO_ID}-${FORMAT}.${EXT} video-${FORMAT}.${EXT}



