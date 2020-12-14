#!/usr/bin/env bash

set -e

. "${SHELL_ROOT_DIR}/src/eslabs.env"

MODE="$1"
MANIFEST="$2"

if [ "${MODE}" == "edit" ]; then
    ${EDITOR} ${KUBE_MANIFESTS_DIR}/${MANIFEST}.sh
    exit 0

fi

${KUBE_MANIFESTS_DIR}/${MANIFEST}.sh ${MODE}
