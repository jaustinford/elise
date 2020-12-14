#!/usr/bin/env bash

set -e

secret='c07b1c559914bd39a6f31878b3952ec4fb4b71da46d1b1022a737c16056082338c67a20ccf102564b4ff8067d0dfc9076ee230c531e302d6f95e8cec87f1f6a2'

if [ "$(echo ${DOCKER_IMAGE_PASSWORD} | sha512sum | awk '{print $1}')" != "$secret" ] || \
   [ ! -f "${SHELL_ROOT_DIR}/src/eslabs.env" ]; then
    exit 1

fi

/bin/bash
