#!/usr/bin/env bash

set -eu

. "${ELISE_ROOT_DIR}/src/elise.env"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/os.sh"

dont_run_if_inside_docker

if [ "$1" == "start" ]; then
    ensure_root
    find_operating_system
    install_docker_rpi

    print_message 'stdout' "deploying ${HAPROXY_NAME}" "${KUBE_MASTER_NODE_HOSTNAME}"
    docker run -dit \
        --name ${HAPROXY_NAME} \
        --publish 443:443 \
        --network bridge \
        --restart unless-stopped \
        --volume ${HAPROXY_VOLUME}:/usr/local/etc/haproxy:ro \
        haproxy:latest 1> /dev/null

elif [ "$1" == "stop" ]; then
    print_message 'stdout' 'destroying haproxy' "${HAPROXY_NAME}"
    docker stop ${HAPROXY_NAME} 1> /dev/null
    docker rm ${HAPROXY_NAME} 1> /dev/null

elif [ "$1" == "reload" ]; then
    print_message 'stdout' 'reloading haproxy' "${HAPROXY_NAME}"
    docker kill -s HUP ${HAPROXY_NAME} 1> /dev/null

fi
