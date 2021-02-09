#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"

TARGET="$1"
PORT="$2"

while true; do
    nmap_scan "${TARGET}" "${PORT}"

done
