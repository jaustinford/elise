#!/usr/bin/env bash

NAME='elise'
VERSION='1.0'

if [ "$1" == 'deploy' ]; then
    docker build ${SHELL_ROOT_DIR} -t ${NAME}:${VERSION}

    docker run -dit \
        --name ${NAME} \
        --env SHELL_ROOT_DIR='/root' \
        --volume "${SHELL_ROOT_DIR}":/root:rw \
         ${NAME}:${VERSION}

    docker exec -it ${NAME} /bin/bash

elif [ "$1" == 'destroy' ]; then
    docker stop ${NAME}
    docker rm ${NAME}
    docker rmi ${NAME}:${VERSION}

fi
