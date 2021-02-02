#!/usr/bin/env bash

set -eu

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

MODE="$1"

if [ "${MODE}" == 'change' ]; then
    grab_loaded_vpn_server
    if [ "$vpn_server" != "${KHARON_EXPRESSVPN_SERVER}" ]; then
        print_message 'stdout' 'new expressvpn server' "${KHARON_EXPRESSVPN_SERVER}"
        "${ELISE_ROOT_DIR}/scripts/run_manifest.sh" apply kharon 1> /dev/null
        "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" restart eslabs kharon

    else
        print_message 'stderr' "'${KHARON_EXPRESSVPN_SERVER}' already connected!"
        exit 1

    fi

fi
