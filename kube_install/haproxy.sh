#!/usr/bin/env bash

set -e

. /mnt/tvault/es-labs/projects/es-labs-scripts/vars/eslabs.env
. "${SCRIPTS_DIR}/echo_colors.sh"
. "${KUBE_INSTALL_SCRIPTS}/os.sh"

if [ "$1" == "start" ]; then
    ensure_root
    install_docker_rpi
    echo -e "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] deploying haproxy  : ${HAPROXY_NAME}"
    docker run -dit \
        --name "${HAPROXY_NAME}" \
        --publish 443:443 \
        --network bridge \
        --restart unless-stopped \
        --volume "${HAPROXY_VOLUME}":/usr/local/etc/haproxy:ro \
        haproxy:latest 1> /dev/null

elif [ "$1" == "stop" ]; then
    echo -e "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] destroying haproxy : ${HAPROXY_NAME}"
    docker stop "${HAPROXY_NAME}" 1> /dev/null
    docker rm "${HAPROXY_NAME}" 1> /dev/null

elif [ "$1" == "reload" ]; then
    echo -e "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] reloading haproxy  : ${HAPROXY_NAME}"
    docker kill -s HUP "${HAPROXY_NAME}" 1> /dev/null

fi
