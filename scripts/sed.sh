#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.env"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"

MODE="$1"
CURRENT_STRING="$2"
NEW_STRING="$3"

if [ "${MODE}" == 'replace' ]; then
    sed_edit  \
        "${CURRENT_STRING}" \
        "${NEW_STRING}"   

fi
