#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

MODE="$1"

if [ "${MODE}" == 'change' ]; then
    print_message 'stdout' 'new expressvpn server' "${KHARON_EXPRESSVPN_SERVER}"

    if [ ! -z $(pod_from_deployment 'eslabs' 'kharon') ]; then
        grab_loaded_vpn_server $(pod_from_deployment 'eslabs' 'kharon')

        if [ "$loaded_vpn_server" != "${KHARON_EXPRESSVPN_SERVER}" ]; then
            "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" stop 'eslabs' 'kharon'
            "${ELISE_ROOT_DIR}/scripts/run_manifest.sh" apply 'kharon' 1> /dev/null
            "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" start 'eslabs' 'kharon'

        else
            print_message 'stderr' 'server already connected!' "${KHARON_EXPRESSVPN_SERVER}"
            exit 1

        fi

    else
        "${ELISE_ROOT_DIR}/scripts/run_manifest.sh" apply 'kharon' 1> /dev/null
        "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" start 'eslabs' 'kharon'

    fi

    grab_loaded_vpn_server $(pod_from_deployment 'eslabs' 'kharon')
    find_wan_from_pod $(pod_from_deployment 'eslabs' 'kharon')

fi
