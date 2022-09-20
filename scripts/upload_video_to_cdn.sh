#!/usr/bin/env bash
FORMAT=$1
rsync -a ${VIDEO_ID}-${FORMAT}.mp4 ${CDN_SERVER_USERNAME}@${CDN_ADDRESS}:${CDN_FILES_FOLDER}/${CONFERENCE}/${VIDEO_ID}/