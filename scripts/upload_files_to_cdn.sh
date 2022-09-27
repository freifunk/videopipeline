#!/usr/bin/env bash

rsync -a --rsync-path="mkdir -p ${CDN_FILES_FOLDER}/${ACRONYM}/${VIDEO_ID}/ && rsync" *.jpg *.vtt ${CDN_SERVER_USERNAME}@${CDN_ADDRESS}:${CDN_FILES_FOLDER}/${ACRONYM}/${VIDEO_ID}/