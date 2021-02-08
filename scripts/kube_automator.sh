 #!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

MODE="$1"

if [ "$#" -ge 1 ]; then
    if [ "${MODE}" == "start" ]; then
        ns="$2"
        deployment="$3"
        kube_start_deployment "$ns" "$deployment" '1'
        pod_from_deployment $ns $deployment
        wait_for_pod_to 'start' "$ns" "$pod"
 
    elif [ "${MODE}" == "stop" ]; then
        ns="$2"
        deployment="$3"
        kube_stop_deployment "$ns" "$deployment"
        pod_from_deployment $ns $deployment
        wait_for_pod_to 'stop' "$ns" "$pod"

    elif [ "${MODE}" == "restart" ]; then
        ns="$2"
        deployment="$3"
        kube_stop_deployment "$ns" "$deployment"
        pod_from_deployment $ns $deployment
        wait_for_pod_to 'stop' "$ns" "$pod"
        kube_start_deployment "$ns" "$deployment" '1'
        pod_from_deployment $ns $deployment
        wait_for_pod_to 'start' "$ns" "$pod"

    elif [ "${MODE}" == "logs" ]; then
        ns="$2"
        deployment="$3"
        container="$4"
        kube_logs_deployment "$ns" "$deployment" "$container"

    elif [ "${MODE}" == "tail" ]; then
        ns="$2"
        deployment="$3"
        container="$4"
        kube_tail_deployment "$ns" "$deployment" "$container"

    elif [ "${MODE}" == "display" ]; then
        ns="$2"
        color_1="${SHELL_KUBE_DISPLAY_BANNER_CODE}"
        color_2="${SHELL_KUBE_DISPLAY_KEY_CODE}"
        kube_display "$ns" "$color_1" "$color_2"

    elif [ "${MODE}" == "exec" ]; then
        ns="$2"
        deployment="$3"
        cmd="$4"
        container="$5"
        pod_from_deployment $ns $deployment
        kube_exec "$ns" "$pod" "$container" "$cmd"

    elif [ "${MODE}" == "shell" ]; then
        ns="$2"
        deployment="$3"
        container="$4"
        pod_from_deployment $ns $deployment
        kube_exec "$ns" "$pod" "$container" '/bin/bash'

    elif [ "${MODE}" == "edit" ]; then
        ns="$2"
        resource="$3"
        object="$4"
        kube_edit "$ns" "$resource" "$object"

    elif [ "${MODE}" == "describe" ]; then
        ns="$2"
        resource="$3"

        if [ "$resource" == 'pod' ]; then
            object="$(pod_from_deployment 'eslabs' $4)"

        else
            object="$4"
        fi

        kube_describe "$ns" "$resource" "$object"

    elif [ "${MODE}" == "nodes" ]; then
        kube_nodes

    elif [ "${MODE}" == "crash" ]; then
        ns="$2"
        deployment="$3"
        container="$4"
        pod="$(pod_from_deployment $ns $deployment)"
        crash_container "$ns" "$pod" "$container"

    elif [ "${MODE}" == "get" ]; then
        ns="$2"
        resource="$3"
        kube_get "$ns" "$resource"

    fi

fi
