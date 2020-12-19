#!/usr/bin/env bash

set -e 

. "${ELISE_ROOT_DIR}/src/elise.env"  
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/os.sh"

ensure_root
dont_run_if_inside_docker
find_operating_system

MODE="$1"

if [ "$#" -ge 1 ]; then
    install_v4l2rtspserver "$operating_system"

    if [ "${MODE}" == "start" ]; then
        python3 "${ELISE_ROOT_DIR}/watcher/rtsp_server.py" start

    elif [ "${MODE}" == "stop" ]; then
        python3 "${ELISE_ROOT_DIR}/watcher/rtsp_server.py" stop

    fi

fi
