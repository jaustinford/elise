#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

MODE="$1"

if [ "$#" -ge 1 ]; then
    if [ "${MODE}" == "start" ]; then
        NAMESPACE="$2"
        APP="$3"
        kube_start_deployment "${NAMESPACE}" \
            "${APP}" \
            '1'
 
    elif [ "${MODE}" == "stop" ]; then
        NAMESPACE="$2"
        APP="$3"
        kube_stop_deployment "${NAMESPACE}" \
            "${APP}"

    elif [ "${MODE}" == "restart" ]; then
        NAMESPACE="$2"
        APP="$3"
        kube_stop_deployment "${NAMESPACE}" \
            "${APP}"

        wait_for_deployment_to_terminate "${APP}"

        kube_start_deployment "${NAMESPACE}" \
            "${APP}" \
            '1'

    elif [ "${MODE}" == "logs" ]; then
        NAMESPACE="$2"
        APP="$3"
        CONTAINER="$4"
        kube_logs_pod "${NAMESPACE}" \
            "${APP}" \
            "${CONTAINER}"

    elif [ "${MODE}" == "tail" ]; then
        NAMESPACE="$2"
        APP="$3"
        CONTAINER="$4"
        kube_tail_pod "${NAMESPACE}" \
            "${APP}" \
            "${CONTAINER}"

    elif [ "${MODE}" == "display" ]; then
        NAMESPACE="$2"
        kube_display "${NAMESPACE}" \
            "${SHELL_KUBE_DISPLAY_BANNER_CODE}" \
            "${SHELL_KUBE_DISPLAY_KEY_CODE}" 2> /dev/null

    elif [ "${MODE}" == "exec" ]; then
        NAMESPACE="$2"
        APP="$3"
        CMD="$4"
        CONTAINER="$5"
        kube_exec "${NAMESPACE}" \
            "${APP}" \
            "${CMD}" \
            "${CONTAINER}"

    elif [ "${MODE}" == "shell" ]; then
        NAMESPACE="$2"
        APP="$3"
        CONTAINER="$4"
        kube_exec "${NAMESPACE}" \
            "${APP}" \
            '/bin/bash' \
            "${CONTAINER}"

    elif [ "${MODE}" == "edit" ]; then
        NAMESPACE="$2"
        APP="$3"
        kube_edit "${NAMESPACE}" \
            "${APP}"

    elif [ "${MODE}" == "describe" ]; then
        NAMESPACE="$2"
        APP="$3"
        kube_describe "${NAMESPACE}" \
            "${APP}"

    elif [ "${MODE}" == "nodes" ]; then
        kube_nodes

    elif [ "${MODE}" == "events" ]; then
        NAMESPACE="$2"
        kube_events "${NAMESPACE}"

    elif [ "${MODE}" == "crash" ]; then
        NAMESPACE="$2"
        APP="$3"
        CONTAINER="$4"
        crash_container "${NAMESPACE}" \
            "${APP}" \
            "${CONTAINER}"

    elif [ "${MODE}" == "get" ]; then
        NAMESPACE="$2"
        RESOURCE="$3"
        kube_get "${NAMESPACE}" \
            "${RESOURCE}"

    fi

fi
