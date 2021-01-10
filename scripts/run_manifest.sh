#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"

MODE="$1"
MANIFEST="$2"

if [ "${MODE}" == "edit" ]; then
    ${EDITOR} ${KUBE_MANIFESTS_DIR}/${MANIFEST}.sh
    exit 0

fi

${KUBE_MANIFESTS_DIR}/${MANIFEST}.sh ${MODE}
