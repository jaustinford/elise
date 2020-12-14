#!/usr/bin/env bash

NAME='elise'
VERSION='1.0'

if [ "$1" == 'deploy' ]; then
    read -sp " password : " DOCKER_IMAGE_PASSWORD
    docker run -dit \
        --name ${NAME} \
        --env DOCKER_IMAGE_PASSWORD=${DOCKER_IMAGE_PASSWORD} \
        --volume "${SHELL_ROOT_DIR}":/root:rw \
         jamesaustin87/${NAME}:${VERSION}

elif [ "$1" == 'build' ]; then
    docker build ${SHELL_ROOT_DIR} -t ${NAME}:${VERSION}

elif [ "$1" == 'destroy' ]; then
    docker stop ${NAME}
    docker rm ${NAME}

elif [ "$1" == 'shell' ]; then
    docker exec -it ${NAME} /bin/bash

fi
