#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"

MODE="$1"
MANIFEST="$2"

if [ "${MODE}" == "edit" ]; then
    ${EDITOR} ${ELISE_ROOT_DIR}/manifests/${MANIFEST}.sh
    exit 0

fi

${ELISE_ROOT_DIR}/manifests/${MANIFEST}.sh ${MODE}
