#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

MODE="$1"

if [ "${MODE}" == 'change' ]; then
    pod_from_deployment 'eslabs' 'kharon'
    grab_loaded_vpn_server "$pod"

    if [ "$loaded_vpn_server" != "${KHARON_EXPRESSVPN_SERVER}" ]; then
        print_message 'stdout' 'new expressvpn server' "${KHARON_EXPRESSVPN_SERVER}"
        "${ELISE_ROOT_DIR}/scripts/run_manifest.sh" apply kharon 1> /dev/null
        "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" restart eslabs kharon
        pod_from_deployment 'eslabs' 'kharon'
        grab_loaded_vpn_server "$pod"
        sleep 4
        find_wan_from_pod "$pod"

    else
        print_message 'stderr' 'server already connected!' "${KHARON_EXPRESSVPN_SERVER}"
        exit 1

    fi

fi
