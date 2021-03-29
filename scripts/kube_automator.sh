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
        ns="$2"
        deployment="$3"
        kube_start_deployment $ns $deployment '1' 1> /dev/null
        pod_from_deployment $ns $deployment 'wait'
        ensure_pod 'start' $ns $pod

    elif [ "${MODE}" == 'stop' ]; then
        ns="$2"
        deployment="$3"

        if [ "$ns" == 'eslabs' ] && \
           [ "$deployment" == 'all' ]; then
            for item in $(kubectl -n eslabs get deployments | grep -v '^NAME' | awk '{print $1}'); do
                kube_stop_deployment 'eslabs' $item 1> /dev/null
                pod_from_deployment 'eslabs' $item 'wait'
                ensure_pod 'stop' 'eslabs' $pod

            done

        else
            kube_stop_deployment $ns $deployment 1> /dev/null
            pod_from_deployment $ns $deployment 'wait'
            ensure_pod 'stop' $ns $pod

        fi

    elif [ "${MODE}" == 'restart' ]; then
        ns="$2"
        deployment="$3"
        kube_stop_deployment $ns $deployment 1> /dev/null
        pod_from_deployment $ns $deployment 'wait'
        ensure_pod 'stop' $ns $pod
        kube_start_deployment $ns $deployment '1' 1> /dev/null
        pod_from_deployment $ns $deployment 'wait'
        ensure_pod 'start' $ns $pod

    elif [ "${MODE}" == 'logs' ]; then
        ns="$2"
        deployment="$3"
        container="$4"

        for item in ${ONE_POD_DEPLOYMENTS[@]}; do
            if [ "$deployment" == "$item" ]; then
                container="$item"

            fi

        done

        kube_logs_deployment $ns $deployment $container

    elif [ "${MODE}" == 'tail' ]; then
        ns="$2"
        deployment="$3"
        container="$4"

        for item in ${ONE_POD_DEPLOYMENTS[@]}; do
            if [ "$deployment" == "$item" ]; then
                container="$item"

            fi

        done

        kube_tail_deployment $ns $deployment $container

    elif [ "${MODE}" == 'display' ]; then
        ns="$2"
        color_1="${SHELL_KUBE_DISPLAY_BANNER_CODE}"
        color_2="${SHELL_KUBE_DISPLAY_KEY_CODE}"
        kube_display $ns $color_1 $color_2 2> /dev/null

    elif [ "${MODE}" == 'exec' ]; then
        ns="$2"
        deployment="$3"
        container="$4"
        cmd="$5"

        for item in ${ONE_POD_DEPLOYMENTS[@]}; do
            if [ "$deployment" == "$item" ]; then
                container="$item"
                cmd="$4"

            fi

        done

        pod_from_deployment $ns $deployment 'wait'
        kube_exec $ns $pod $container "$cmd"

    elif [ "${MODE}" == 'shell' ]; then
        ns="$2"
        deployment="$3"
        container="$4"

        for item in ${ONE_POD_DEPLOYMENTS[@]}; do
            if [ "$deployment" == "$item" ]; then
                container="$item"

            fi

        done

        pod_from_deployment $ns $deployment 'wait'
        kube_exec $ns $pod $container '/bin/bash'

    elif [ "${MODE}" == 'edit' ]; then
        ns="$2"
        resource="$3"
        object="$4"
        kube_edit $ns $resource $object

    elif [ "${MODE}" == 'describe' ]; then
        ns="$2"
        resource="$3"

        if [ "$resource" == 'pod' ]; then
            pod_from_deployment $ns $4 'wait'
            object="$pod"

        else
            object="$4"

        fi

        kube_describe $ns $resource $object

    elif [ "${MODE}" == 'nodes' ]; then
        kube_nodes

    elif [ "${MODE}" == 'crash' ]; then
        ns="$2"
        deployment="$3"
        container="$4"

        for item in ${ONE_POD_DEPLOYMENTS[@]}; do
            if [ "$deployment" == "$item" ]; then
                container="$item"

            fi

        done

        pod_from_deployment $ns $deployment 'wait'
        crash_container $ns $pod "$container"

    elif [ "${MODE}" == 'get' ]; then
        ns="$2"
        resource="$3"
        kube_get $ns $resource

    fi

fi
