#!/usr/bin/python3
"""Publish event + recordings to voctoweb (media.freifunk.net).

Canonical script used by GoCD (processing-pipeline). Size must be bytes
(VOC 2026 / current freifunk voctoweb). Prefer Authorization header over body api_key.
"""
import os
import subprocess
import sys

import requests


def env(name: str) -> str:
    try:
        return os.environ[name]
    except KeyError:
        print(f"missing environment variable: {name}", file=sys.stderr)
        sys.exit(1)


def ffprobe_duration_seconds(path: str) -> int:
    out = subprocess.check_output(
        [
            "ffprobe",
            "-loglevel",
            "quiet",
            "-print_format",
            "default",
            "-show_format",
            path,
        ],
        text=True,
    )
    for line in out.splitlines():
        if line.startswith("duration="):
            return int(float(line.split("=", 1)[1]))
    raise RuntimeError(f"no duration in ffprobe output for {path}")


def ffprobe_stream_dim(path: str, key: str) -> int:
    out = subprocess.check_output(
        [
            "ffprobe",
            "-v",
            "error",
            "-select_streams",
            "v:0",
            "-show_entries",
            f"stream={key}",
            "-of",
            "default=noprint_wrappers=1:nokey=1",
            path,
        ],
        text=True,
    ).strip()
    return int(out)


def file_size_bytes(path: str) -> int:
    return os.stat(path).st_size


def post_json(session: requests.Session, url: str, payload: dict) -> requests.Response:
    res = session.post(url, json=payload, timeout=120)
    try:
        res.raise_for_status()
    except requests.HTTPError as exc:
        print(f"HTTP {res.status_code} for {url}: {res.text}", file=sys.stderr)
        raise SystemExit(1) from exc
    return res


def main() -> None:
    voctoweb_url = env("VOCTOWEB_URL").rstrip("/")
    api_key = env("API_KEY")
    acronym = env("ACRONYM")
    language = env("LANGUAGE")
    slug = env("SLUG")
    title = env("TITLE")
    subtitle = env("SUBTITLE")
    description = env("DESCRIPTION")
    persons = env("PERSONS").split()
    tags = env("TAGS").split()
    link = env("LINK")
    date = env("DATE")
    release_date = env("RELEASE_DATE")
    video_id = env("VIDEO_ID")

    mp4 = "video-h264.mp4"
    webm = "video-webm.webm"

    video_length = ffprobe_duration_seconds(mp4)
    video_width = ffprobe_stream_dim(mp4, "width")
    video_height = ffprobe_stream_dim(mp4, "height")
    mp4_size = file_size_bytes(mp4)
    webm_size = file_size_bytes(webm)

    session = requests.Session()
    session.headers.update(
        {
            "Content-Type": "application/json",
            "Authorization": f"Token token={api_key}",
            "Accept": "application/json",
        }
    )

    post_json(
        session,
        f"{voctoweb_url}/api/events",
        {
            "api_key": api_key,
            "acronym": acronym,
            "event": {
                "poster_filename": f"{acronym}/{video_id}/{video_id}_preview.jpg",
                "thumb_filename": f"{acronym}/{video_id}/{video_id}_thumb.jpg",
                "timeline_filename": f"{acronym}/{video_id}/{video_id}.timeline.jpg",
                "thumbnails_filename": f"{acronym}/{video_id}/{video_id}.vtt",
                "guid": video_id,
                "original_language": language,
                "slug": slug,
                "title": title,
                "subtitle": subtitle,
                "description": description,
                "persons": persons,
                "tags": tags,
                "link": link,
                "date": date,
                "release_date": release_date,
            },
        },
    )

    for filename, mime, size in (
        (f"{video_id}-h264.mp4", "video/mp4", mp4_size),
        (f"{video_id}-webm.webm", "video/webm", webm_size),
    ):
        post_json(
            session,
            f"{voctoweb_url}/api/recordings",
            {
                "api_key": api_key,
                "guid": video_id,
                "recording": {
                    "filename": filename,
                    "folder": f"{acronym}/{video_id}",
                    "mime_type": mime,
                    "language": language,
                    "size": size,
                    "length": video_length,
                    "width": video_width,
                    "height": video_height,
                },
            },
        )

    print(
        f"published {video_id}: mp4={mp4_size}B webm={webm_size}B "
        f"{video_width}x{video_height} {video_length}s"
    )


if __name__ == "__main__":
    main()
