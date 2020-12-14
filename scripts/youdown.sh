#!/usr/bin/env bash

set -e

. "${SHELL_ROOT_DIR}/src/youtube-dl-wrapper.sh"

OPTION="$1"
DOWNLOAD_DIR="$2"
DOWNLOAD_URL="$3"

if [ "$#" == 3 ]; then
    DOWNLOAD_NAME=$(grab_download_name "${DOWNLOAD_URL}")

    download_file \
        "${OPTION}" \
        "${DOWNLOAD_DIR}" \
        "${DOWNLOAD_NAME}" \
        "${DOWNLOAD_URL}" \
        "${YOUDOWN_AUDIO_QUALITY}"

else
    echo \
    "[!] Usage:
    youdown video /path/to/download/folder https://www.youtube.com/watch?v=xxxxxxxxxxxx
    youdown audio /path/to/download/folder https://www.youtube.com/watch?v=xxxxxxxxxxxx"

fi
