#!/usr/bin/env bash

# create the folder structure locally first
mkdir -p ${ACRONYM}/${VIDEO_ID}/

# Then upload that created structure to cdn
rsync -4 -a ${ACRONYM} ${CDN_ADDRESS}:/${CDN_FILES_FOLDER}/

# Now upload the files to that location
rsync -4 -a *.jpg *.vtt ${CDN_ADDRESS}:/${CDN_FILES_FOLDER}/${ACRONYM}/${VIDEO_ID}/



