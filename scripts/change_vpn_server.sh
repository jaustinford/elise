#!/usr/bin/env bash

set -eu

. "${ELISE_ROOT_DIR}/src/elise.env"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"

MODE="$1"

if [ "${MODE}" == 'change' ]; then
    print_message 'stdout' 'changing expressvpn server' "${KHARON_EXPRESSVPN_SERVER}"
    "${ELISE_ROOT_DIR}/scripts/run_manifest.sh" apply kharon 1> /dev/null
    "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" restart eslabs kharon

fi