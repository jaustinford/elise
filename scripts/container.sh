#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"

CONTAINER_NAME='elise'
IMAGE_NAME='jamesaustin87/es-centos'
IMAGE_VERSION='1.0'

if [ "${MSYSTEM}" == 'MINGW64' ]; then
    ROOT_MOUNT_PATH='//root'
    ROOT_VOLUME="/${ELISE_ROOT_DIR}://root"
    SHELL_CMD="winpty docker exec -it ${CONTAINER_NAME} //bin/bash"

else
    ROOT_MOUNT_PATH='/root'
    ROOT_VOLUME="${ELISE_ROOT_DIR}:/root"
    SHELL_CMD="docker exec -it ${CONTAINER_NAME} /bin/bash"

fi

if [ "$1" == 'deploy' ]; then
    docker run -dit \
        --name ${CONTAINER_NAME} \
        --network=host \
        --privileged \
        --env TZ=${DOCKER_TIMEZONE} \
        --env HOST_HOSTNAME="$(hostname)" \
        --env ELISE_ROOT_DIR=${ROOT_MOUNT_PATH} \
        --volume ${ROOT_VOLUME}:rw \
        ${IMAGE_NAME}:${IMAGE_VERSION}

    ${SHELL_CMD}

elif [ "$1" == 'start' ]; then
    docker start ${CONTAINER_NAME}
    ${SHELL_CMD}

elif [ "$1" == 'stop' ]; then
    docker stop ${CONTAINER_NAME}

elif [ "$1" == 'remove' ]; then
    docker stop ${CONTAINER_NAME}
    docker rm ${CONTAINER_NAME}

elif [ "$1" == 'destroy' ]; then
    docker stop ${CONTAINER_NAME}
    docker rm ${CONTAINER_NAME}
    docker rmi ${IMAGE_NAME}:${IMAGE_NAME}

elif [ "$1" == 'shell' ]; then
    ${SHELL_CMD}

fi
