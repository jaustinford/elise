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
        if [ "$(hostname)" == 'watcher01.labs.elysianskies.com' ]; then
            print_message 'stdout' 'deploying rtsp stream' "$(hostname):8554/doorway"
            v4l2-ctl -d /dev/video0 --set-ctrl=led1_mode=0
            v4l2-ctl -d /dev/video0 --set-ctrl=sharpness=255
            v4l2-ctl -d /dev/video0 --set-ctrl=focus_auto=0
            v4l2-ctl -d /dev/video0 --set-ctrl=focus_absolute=0

            v4l2rtspserver \
                -P 8554 -p 8554 \
                -U "${LAB_WATCHER_USERNAME}:${LAB_WATCHER_PASSWORD}" \
                -W ${BIGBROTHER_CAMERA_WIDTH} -H ${BIGBROTHER_CAMERA_HEIGHT} \
                -u doorway /dev/video0 1> /dev/null &

            print_message 'stdout' 'deploying rtsp stream' "$(hostname):8555/dining"
            v4l2-ctl -d /dev/video2 --set-ctrl=led1_mode=0
            v4l2-ctl -d /dev/video2 --set-ctrl=sharpness=255
            v4l2-ctl -d /dev/video2 --set-ctrl=focus_auto=0
            v4l2-ctl -d /dev/video2 --set-ctrl=focus_absolute=0

            v4l2rtspserver \
                -P 8555 -p 8555 \
                -U "${LAB_WATCHER_USERNAME}:${LAB_WATCHER_PASSWORD}" \
                -W ${BIGBROTHER_CAMERA_WIDTH} -H ${BIGBROTHER_CAMERA_HEIGHT} \
                -u dining /dev/video2 1> /dev/null &


        elif [ "$(hostname)" == 'watcher02.labs.elysianskies.com' ]; then
            print_message 'stdout' 'deploying rtsp stream' "$(hostname):8554/safe"
            v4l2-ctl -d /dev/video0 --set-ctrl=led1_mode=0
            v4l2-ctl -d /dev/video0 --set-ctrl=sharpness=255
            v4l2-ctl -d /dev/video0 --set-ctrl=focus_auto=0
            v4l2-ctl -d /dev/video0 --set-ctrl=focus_absolute=0

            v4l2rtspserver \
                -P 8554 -p 8554 \
                -U "${LAB_WATCHER_USERNAME}:${LAB_WATCHER_PASSWORD}" \
                -W ${BIGBROTHER_CAMERA_WIDTH} -H ${BIGBROTHER_CAMERA_HEIGHT} \
                -u safe /dev/video0 1> /dev/null &

            print_message 'stdout' 'deploying rtsp stream' "$(hostname):8555/office"
            v4l2-ctl -d /dev/video2 --set-ctrl=led1_mode=0
            v4l2-ctl -d /dev/video2 --set-ctrl=sharpness=255
            v4l2-ctl -d /dev/video2 --set-ctrl=focus_auto=0
            v4l2-ctl -d /dev/video2 --set-ctrl=focus_absolute=0

            v4l2rtspserver \
                -P 8555 -p 8555 \
                -U "${LAB_WATCHER_USERNAME}:${LAB_WATCHER_PASSWORD}" \
                -W ${BIGBROTHER_CAMERA_WIDTH} -H ${BIGBROTHER_CAMERA_HEIGHT} \
                -u office /dev/video2 1> /dev/null &

        fi

    elif [ "${MODE}" == "stop" ]; then
        for pid in $(/bin/pidof v4l2rtspserver); do 
            print_message 'stdout' 'killing process' "$pid"
            kill -9 $pid

        done

    fi

fi
