#!/usr/bin/env bash

CONTAINER_NAME='elise'
IMAGE_NAME='jamesaustin87/elise'
IMAGE_TAG='latest'
DOCKER_TIMEZONE='America/Denver'

if [ "${MSYSTEM}" == 'MINGW64' ]; then
    ROOT_MOUNT_PATH='//root'
    ROOT_VOLUME="/${ELISE_ROOT_DIR}://root"
    SHELL_CMD="winpty docker exec -it ${CONTAINER_NAME} //bin/bash -c"

else
    ROOT_MOUNT_PATH='/root'
    ROOT_VOLUME="${ELISE_ROOT_DIR}:/root"
    SHELL_CMD="docker exec -it ${CONTAINER_NAME} /bin/bash -c"

fi

if [ "$1" == 'deploy' ]; then
    docker run -dit \
        --name "${CONTAINER_NAME}" \
        --network=bridge \
        --privileged \
        --env TZ="${DOCKER_TIMEZONE}" \
        --env HOST_HOSTNAME="$(hostname)" \
        --env ELISE_ROOT_DIR="${ROOT_MOUNT_PATH}" \
        --volume "${ROOT_VOLUME}":rw \
        "${IMAGE_NAME}:${IMAGE_TAG}"

elif [ "$1" == 'start' ]; then
    docker start "${CONTAINER_NAME}"

elif [ "$1" == 'stop' ]; then
    docker stop "${CONTAINER_NAME}"

elif [ "$1" == 'restart' ]; then
    docker restart "${CONTAINER_NAME}"

elif [ "$1" == 'remove' ]; then
    docker stop "${CONTAINER_NAME}"
    docker rm "${CONTAINER_NAME}"

elif [ "$1" == 'destroy' ]; then
    docker stop "${CONTAINER_NAME}"
    docker rm "${CONTAINER_NAME}"
    docker rmi "${IMAGE_NAME}:${IMAGE_TAG}"

elif [ "$1" == 'shell-min' ]; then
    /bin/bash -c "${SHELL_CMD} 'ELISE_PROFILE=1 /bin/bash'"

elif [ "$1" == 'shell-full' ]; then
    /bin/bash -c "${SHELL_CMD} 'ELISE_PROFILE=1 ENABLE_INIT=1 /bin/bash'"

elif [ "$1" == 'logs' ]; then
    docker logs "${CONTAINER_NAME}"

fi
