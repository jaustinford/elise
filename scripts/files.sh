#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"

MODE="$1"
CURRENT_STRING="$2"
NEW_STRING="$3"

if [ "${MODE}" == 'sed' ]; then
    sed_edit "${CURRENT_STRING}" "${NEW_STRING}"   

elif [ "${MODE}" == 'lines' ]; then
    permissions_and_dos_line_endings "${ELISE_ROOT_DIR}"

fi
