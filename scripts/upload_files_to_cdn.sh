#!/usr/bin/env bash

rsync -a *.jpg *.vtt ${CDN_SERVER_USERNAME}@${CDN_ADDRESS}:${CDN_FILES_FOLDER}/${ACRONYM}/${VIDEO_ID}/