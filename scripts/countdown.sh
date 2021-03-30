#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"

COMMAND="$1"
TIME="$2"

if [ ! -z "${TIME}" ] && \
   [ ! -z "${COMMAND}" ]; then
    print_message stdout "scheduled for ${TIME}" "${COMMAND}"
    while [ "$(date +%H:%M:%S)" != "${TIME}" ]; do
        sleep 1

    done

fi

print_message stdout "executing ${COMMAND}"
/bin/bash -c "${COMMAND}"
