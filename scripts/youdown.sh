#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/youtube-dl-wrapper.sh"

OPTION="$1"
DOWNLOAD_URL="$2"
DOWNLOAD_DIR='/root/dropoff'

if [ "$#" == 2 ]; then
    ensure_dropoff '/root/dropoff'
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
    youdown video https://www.youtube.com/watch?v=xxxxxxxxxxxx
    youdown audio https://www.youtube.com/watch?v=xxxxxxxxxxxx"

fi
