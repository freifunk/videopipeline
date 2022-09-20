#!/usr/bin/env bash

rsync -a *.jpg ${CDN_SERVER_USERNAME}@${CDN_ADDRESS}:${CDN_FILES_FOLDER}/${CONFERENCE}/${VIDEO_ID}/