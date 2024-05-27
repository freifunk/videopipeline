#!/usr/bin/env bash

rsync -4 -a --rsync-path="mkdir -p ${CDN_FILES_FOLDER}/${ACRONYM}/${VIDEO_ID}/ && rsync" *.jpg *.vtt ${CDN_ADDRESS}:/${CDN_FILES_FOLDER}/${ACRONYM}/${VIDEO_ID}/


