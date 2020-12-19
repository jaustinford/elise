#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.env"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/os.sh"

dont_run_if_inside_docker

if [ "$1" == "deploy" ]; then
    ensure_root
    find_operating_system
    install_docker_rpi

    print_message 'stdout' 'decoding tls for volume'
    echo "${LAB_NGINX_CERT}" | base64 -d > "${ELISE_ROOT_DIR}/haproxy/nginx.crt"
    echo "${LAB_NGINX_KEY}" | base64 -d > "${ELISE_ROOT_DIR}/haproxy/nginx.crt.key"
    
    print_message 'stdout' "deploying ${HAPROXY_NAME}" "${KUBE_MASTER_NODE_HOSTNAME}"
    docker run -dit \
        --name ${HAPROXY_NAME} \
        --publish 443:443 \
        --network bridge \
        --volume ${ELISE_ROOT_DIR}/haproxy:/usr/local/etc/haproxy:ro \
        --restart unless-stopped \
        haproxy:latest 1> /dev/null

elif [ "$1" == "destroy" ]; then
    print_message 'stdout' 'destroying haproxy' "${HAPROXY_NAME}"
    docker stop ${HAPROXY_NAME} &> /dev/null
    docker rm ${HAPROXY_NAME} &> /dev/null
    docker rmi haproxy:latest &> /dev/null
    rm -f "${ELISE_ROOT_DIR}/haproxy/nginx.crt"
    rm -f "${ELISE_ROOT_DIR}/haproxy/nginx.crt.key"

elif [ "$1" == "reload" ]; then
    print_message 'stdout' 'reloading haproxy' "${HAPROXY_NAME}"
    docker kill -s HUP ${HAPROXY_NAME} 1> /dev/null

fi
