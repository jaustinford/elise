#!/usr/bin/env bash

set -eu

. "${ELISE_ROOT_DIR}/src/elise.ini"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/os.sh"

if [ "$1" == "start" ]; then
    ensure_root
    find_operating_system
    install_docker_rpi

    print_message 'stdout' "deploying ${HAPROXY_NAME} on" "$KUBE_MASTER_NODE_HOSTNAME"
    ssh ${KUBE_MASTER_NODE_HOSTNAME} \
        "docker run -dit \
            --name ${HAPROXY_NAME} \
            --publish 443:443 \
            --network bridge \
            --restart unless-stopped \
            --volume ${HAPROXY_VOLUME}:/usr/local/etc/haproxy:ro \
            haproxy:latest"

elif [ "$1" == "stop" ]; then
    print_message 'stdout' 'destroying haproxy' "${HAPROXY_NAME}"
    ssh ${KUBE_MASTER_NODE_HOSTNAME} \
        "docker stop ${HAPROXY_NAME}; \
         docker rm ${HAPROXY_NAME}"

elif [ "$1" == "reload" ]; then
    print_message 'stdout' 'reloading haproxy' "${HAPROXY_NAME}"
    ssh ${KUBE_MASTER_NODE_HOSTNAME} \
        "docker kill -s HUP ${HAPROXY_NAME}"

fi
