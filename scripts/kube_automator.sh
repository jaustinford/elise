 #!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

MODE="$1"
ONE_POD_DEPLOYMENTS=(
    'acme'
    'bigbrother'
    'filebrowser'
    'nagios'
)

if [ "$#" -ge 1 ]; then
    if [ "${MODE}" == 'start' ]; then
        namespace="$2"
        deployment="$3"

        kube_start_deployment "$namespace" "$deployment" 1 1> /dev/null
        ensure_pod start "$namespace" "$(pod_from_deployment $namespace $deployment wait)"

    elif [ "${MODE}" == 'stop' ]; then
        namespace="$2"
        deployment="$3"

        if [ "$namespace" == 'eslabs' ] && \
           [ "$deployment" == 'all' ]; then
            for item in $(kubectl -n eslabs get deployments | grep -v '^NAME' | awk '{print $1}'); do
                kube_stop_deployment eslabs "$item" 1> /dev/null
                ensure_pod stop eslabs "$(pod_from_deployment eslabs $item wait)"

            done

        else
            kube_stop_deployment "$namespace" "$deployment" 1> /dev/null
            ensure_pod stop "$namespace" "$(pod_from_deployment $namespace $deployment 'wait')"

        fi

    elif [ "${MODE}" == 'restart' ]; then
        namespace="$2"
        deployment="$3"

        kube_stop_deployment "$namespace" "$deployment" 1> /dev/null
        ensure_pod stop "$namespace" "$(pod_from_deployment $namespace $deployment wait)"
        kube_start_deployment "$namespace" "$deployment" 1 1> /dev/null
        ensure_pod start "$namespace" "$(pod_from_deployment $namespace $deployment wait)"

    elif [ "${MODE}" == 'logs' ]; then
        namespace="$2"
        deployment="$3"
        container="$4"

        for item in ${ONE_POD_DEPLOYMENTS[@]}; do
            if [ "$deployment" == "$item" ]; then container="$item"
            fi

        done

        kube_logs_deployment "$namespace" "$deployment" "$container"

    elif [ "${MODE}" == 'tail' ]; then
        namespace="$2"
        deployment="$3"
        container="$4"

        for item in ${ONE_POD_DEPLOYMENTS[@]}; do
            if [ "$deployment" == "$item" ]; then container="$item"
            fi

        done

        kube_tail_deployment "$namespace" "$deployment" "$container"

    elif [ "${MODE}" == 'display' ]; then
        namespace="$2"
        color_1="${SHELL_KUBE_DISPLAY_BANNER_CODE}"
        color_2="${SHELL_KUBE_DISPLAY_KEY_CODE}"

        kube_display "$namespace" "$color_1" "$color_2" 2> /dev/null

    elif [ "${MODE}" == 'exec' ]; then
        namespace="$2"
        deployment="$3"
        container="$4"
        cmd="$5"

        for item in ${ONE_POD_DEPLOYMENTS[@]}; do
            if [ "$deployment" == "$item" ]; then
                container="$item"
                cmd="$4"

            fi

        done

        kube_exec "$namespace" "$(pod_from_deployment $namespace $deployment wait)" "$container" "$cmd"

    elif [ "${MODE}" == 'shell' ]; then
        namespace="$2"
        deployment="$3"
        container="$4"

        for item in ${ONE_POD_DEPLOYMENTS[@]}; do
            if [ "$deployment" == "$item" ]; then container="$item"
            fi

        done

        kube_exec "$namespace" "$(pod_from_deployment $namespace $deployment wait)" "$container" '/bin/bash'

    elif [ "${MODE}" == 'edit' ]; then
        namespace="$2"
        resource="$3"
        object="$4"

        kube_edit "$namespace" "$resource" "$object"

    elif [ "${MODE}" == 'describe' ]; then
        namespace="$2"
        resource="$3"

        if [ "$resource" == 'pod' ]; then object="$(pod_from_deployment $namespace $4 wait)"
        else object="$4"
        fi

        kube_describe "$namespace" "$resource" "$object"

    elif [ "${MODE}" == 'nodes' ]; then
        kube_nodes

    elif [ "${MODE}" == 'crash' ]; then
        namespace="$2"
        deployment="$3"
        container="$4"

        for item in ${ONE_POD_DEPLOYMENTS[@]}; do
            if [ "$deployment" == "$item" ]; then container="$item"
            fi

        done

        crash_container "$namespace" "$(pod_from_deployment $namespace $deployment wait)" "$container"

    elif [ "${MODE}" == 'get' ]; then
        namespace="$2"
        resource="$3"

        kube_get "$namespace" "$resource"

    fi

fi
