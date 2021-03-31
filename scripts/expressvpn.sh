#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

MODE="$1"
SERVER="$2"

if [ "${MODE}" == 'change' ]; then
    if [ -z "${SERVER}" ]; then SERVER="${KHARON_EXPRESSVPN_SERVER}"
    fi

    grab_loaded_vpn_server "$(pod_from_deployment eslabs kharon)"

    if [ "$loaded_vpn_server" != "${SERVER}" ]; then
        sed -i -E "s/^KHARON_EXPRESSVPN_SERVER.*$/KHARON_EXPRESSVPN_SERVER='${SERVER}'/g" "${ELISE_ROOT_DIR}/src/elise.sh"
        . "${ELISE_ROOT_DIR}/src/elise.sh"
        "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" stop eslabs kharon
        "${ELISE_ROOT_DIR}/scripts/run_manifest.sh" apply kharon 1> /dev/null
        "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" start eslabs kharon


    else
        print_message stderr 'server already connected!' "${SERVER}"
        exit 1

    fi

    grab_loaded_vpn_server "$(pod_from_deployment eslabs kharon)"
    find_wan_from_pod "$(pod_from_deployment eslabs kharon)"

fi
