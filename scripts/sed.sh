#!/usr/bin/env bash

. "${SHELL_ROOT_DIR}/src/eslabs.ini"
. "${SHELL_ROOT_DIR}/src/colors.sh"
. "${SHELL_ROOT_DIR}/src/general.sh"

MODE="$1"
CURRENT_STRING="$2"
NEW_STRING="$3"

if [ "${MODE}" == 'replace' ]; then
    sed_edit  "${CURRENT_STRING}" "${NEW_STRING}"   

fi