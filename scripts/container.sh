#!/usr/bin/env bash

set -eu

NAME='elise'
VERSION='1.0'

if [ "$1" == 'build' ]; then
    docker build ${SHELL_ROOT_DIR} -t ${NAME}:${VERSION}

elif [ "$1" == 'deploy' ]; then
    docker build ${SHELL_ROOT_DIR} -t ${NAME}:${VERSION}

    docker run -dit \
        --name ${NAME} \
        --env SHELL_ROOT_DIR='/root' \
        --volume ${SHELL_ROOT_DIR}:/root:rw \
         ${NAME}:${VERSION}

    docker exec -it ${NAME} /bin/bash

elif [ "$1" == 'start' ]; then
    docker start ${NAME}

elif [ "$1" == 'stop' ]; then
    docker stop ${NAME}

elif [ "$1" == 'destroy' ]; then
    docker stop ${NAME}
    docker rm ${NAME}
    docker rmi ${NAME}:${VERSION}

elif [ "$1" == 'shell' ]; then
    docker exec -it ${NAME} /bin/bash

fi
