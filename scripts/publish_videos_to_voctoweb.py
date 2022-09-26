#!/usr/bin/python3 
import requests
import subprocess
import os
from math import ceil



# reading environment variables

VOCTOWEB_URL=os.environ['VOCTOWEB_URL']
API_KEY=os.environ['API_KEY']
ACRONYM=os.environ['ACRONYM']
LANGUAGE=os.environ['LANGUAGE']
SLUG=os.environ['SLUG']
TITLE=os.environ['TITLE']
SUBTITLE=os.environ['SUBTITLE']
DESCRIPTION=os.environ['DESCRIPTION']
PERSONS=os.environ['PERSONS'].split()
TAGS=os.environ['TAGS'].split()
LINK=os.environ['LINK']
DATE=os.environ['DATE']
RELEASE_DATE=os.environ['RELEASE_DATE']
VIDEO_ID=os.environ['VIDEO_ID']


VIDEO_LENGTH=int(subprocess.check_output(r"ffprobe -loglevel quiet -print_format default -show_format video-h264.mp4 | grep duration= | sed -e 's/duration=\([[:digit:]]*\).*/\1/g'",shell=True))
VIDEO_HEIGHT=int(subprocess.check_output("ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 video-h264.mp4",shell=True))
VIDEO_WIDTH=int(subprocess.check_output("ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 video-h264.mp4",shell=True))
MP4_SIZE=ceil(int(subprocess.check_output("stat -c '%s' video-h264.mp4",shell=True))/(1024*1024))
WEBM_SIZE=ceil(int(subprocess.check_output("stat -c '%s' video-webm.webm",shell=True))/(1024*1024))


headers = {"Content-Type": "application/json"}
 

# event creation

res = requests.post(f'{VOCTOWEB_URL}/api/events',headers=headers,json={
    "api_key":API_KEY,
    "acronym":ACRONYM,
    "event":{
      "poster_filename":f'{ACRONYM}/{VIDEO_ID}/{VIDEO_ID}_preview.jpg',
      "thumb_filename":f'{ACRONYM}/{VIDEO_ID}/{VIDEO_ID}_thumb.jpg',
      "timeline_filename":f'{ACRONYM}/{VIDEO_ID}/{VIDEO_ID}.timeline.jpg',
      "thumbnails_filename":f'{ACRONYM}/{VIDEO_ID}/{VIDEO_ID}.vtt',
      "guid":VIDEO_ID,
      "original_language":LANGUAGE,
      "slug":SLUG,
      "title":TITLE,
      "subtitle":SUBTITLE,
      "description":DESCRIPTION,
      "persons":PERSONS,
      "tags":TAGS,
      "link":LINK,
      "date":DATE,
      "release_date":RELEASE_DATE
    }
})


# adding h264 recording
res = requests.post(f'{VOCTOWEB_URL}/api/recordings',headers=headers,json={
    "api_key":API_KEY,
    "guid":VIDEO_ID,
    "recording":{
      "filename":f'{VIDEO_ID}-h264.mp4',
      "folder":f'{ACRONYM}/{VIDEO_ID}',
      "mime_type":'video/mp4',
      "language":LANGUAGE,
      "size":MP4_SIZE,
      "length":VIDEO_LENGTH,
      "width":VIDEO_HEIGHT,
      "height":VIDEO_WIDTH,
    }
})

# adding webm recording

res = requests.post(f'{VOCTOWEB_URL}/api/recordings',headers=headers,json={
    "api_key":API_KEY,
    "guid":VIDEO_ID,
    "recording":{
      "filename":f'{VIDEO_ID}-webm.webm',
      "folder":f'{ACRONYM}/{VIDEO_ID}',
      "mime_type":'video/webm',
      "language":LANGUAGE,
      "size":WEBM_SIZE,
      "length":VIDEO_LENGTH,
      "width":VIDEO_HEIGHT,
      "height":VIDEO_WIDTH,
    }
})
