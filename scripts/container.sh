#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"

NAME='elise'
VERSION='1.0'

if [ "${MSYSTEM}" == 'MINGW64' ]; then
    ROOT_MOUNT_PATH='//root'
    ROOT_VOLUME="/${ELISE_ROOT_DIR}://root"
    SHELL_CMD="winpty docker exec -it ${NAME} //bin/bash"

else
    ROOT_MOUNT_PATH='/root'
    ROOT_VOLUME="${ELISE_ROOT_DIR}:/root"
    SHELL_CMD="docker exec -it ${NAME} /bin/bash"

fi

if [ "$1" == 'build' ]; then
    docker build ${ELISE_ROOT_DIR} -t ${NAME}:${VERSION}

elif [ "$1" == 'deploy' ]; then
    docker build ${ELISE_ROOT_DIR} -t ${NAME}:${VERSION}

    docker run -dit \
        --name ${NAME} \
        --network=host \
        --privileged \
        --env TZ=${DOCKER_TIMEZONE} \
        --env HOST_HOSTNAME="$(hostname)" \
        --env ELISE_ROOT_DIR=${ROOT_MOUNT_PATH} \
        --volume ${ROOT_VOLUME}:rw \
        ${NAME}:${VERSION}

    ${SHELL_CMD}

elif [ "$1" == 'start' ]; then
    docker start ${NAME}
    ${SHELL_CMD}

elif [ "$1" == 'stop' ]; then
    docker stop ${NAME}

elif [ "$1" == 'remove' ]; then
    docker stop ${NAME}
    docker rm ${NAME}

elif [ "$1" == 'destroy' ]; then
    docker stop ${NAME}
    docker rm ${NAME}
    docker rmi ${NAME}:${VERSION}

elif [ "$1" == 'shell' ]; then
    ${SHELL_CMD}

fi
