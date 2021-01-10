wait_for_deployment_to_terminate () {
    while [ ! -z "$(kubectl get pods --all-namespaces | grep $1 | egrep '\-[a-z0-9]{1,}\-[a-z0-9]{1,}')" ]; do
        sleep 5

    done
}

kube_start_deployment () {
    print_message 'stdout' "deploy pods ($3)" "$1/$2"
    kubectl -n "$1" scale --replicas="$3" deployment/"$2" 1> /dev/null
}

kube_stop_deployment () {
    print_message 'stdout' 'delete pods' "$1/$2"
    kubectl -n "$1" scale --replicas=0 deployment/"$2" 1> /dev/null
}

kube_logs_pod () {
    if [ -z "$3" ]; then
        kubectl -n "$1" logs "deployment/$2"

    else
        kubectl -n "$1" logs "deployment/$2" -c "$3"

    fi
}

kube_tail_pod () {
    if [ -z "$3" ]; then
        kubectl -n "$1" logs -f --tail=50 "deployment/$2"

    else
        kubectl -n "$1" logs -f --tail=50 "deployment/$2" -c "$3"

    fi
}

kube_display () {
    echo -e "

$2    K U B E R N E T E S    O N    E L Y S I A N    S K I E S $ECHO_RESET

      namespace : $3 $1                                        $ECHO_RESET

$3  nodes                                                      $ECHO_RESET

$(kubectl get nodes -o wide)

$3  pods                                                       $ECHO_RESET

$(kubectl -n $1 -o wide get pods)

$3  services                                                   $ECHO_RESET

$(kubectl -n $1 -o wide get services)

$3  endpoints                                                  $ECHO_RESET

$(kubectl -n $1 -o wide get endpoints)

$3  ingresses                                                  $ECHO_RESET

$(kubectl -n $1 -o wide get ingresses)

$3  events                                                     $ECHO_RESET

$(kubectl -n $1 -o wide get events)
"
}

kube_exec () {
    if [ ! -z "$4" ]; then
        kubectl -n "$1" exec --stdin --tty \
            "$(kubectl -n $1 get pods | grep $2 | awk '{print $1}')" -c "$4" -- /bin/bash

    else
        kubectl -n "$1" exec --stdin --tty \
            "$(kubectl -n $1 get pods | grep $2 | awk '{print $1}')" -- /bin/bash

    fi
}

kube_edit () {
    kubectl -n "$1" edit deployment/"$2"
}

kube_describe () {
    kubectl -n "$1" describe pod $(kubectl -n $1 get pods | grep $2 | awk '{print $1}')
}

kube_nodes () {
    kubectl get nodes -o wide
}

kube_events () {
    kubectl -n "$1" get events
}

kube_config () {
    print_message 'stdout' 'generating kubernetes config' "${ELISE_ROOT_DIR}/.kube/config"
    mkdir -p "${ELISE_ROOT_DIR}/.kube"
    echo "${KUBE_CONFIG_FILE}" | base64 -d > "${ELISE_ROOT_DIR}/.kube/config"
}

crash_container () {
    # meant as a way to force kubernetes to restart containers by crashing them internally
    # as opposed to using kubernetes to kill the pod. useful in troubleshooting boot order
    # issues with pods that have multiple containers.
    print_message 'stdout' 'crashing container' "$1/$2:$3"
    kubectl -n "$1" exec $(kubectl -n $1 get pods | grep $2 | awk '{print $1}') -c "$3" -- /sbin/killall5
}

grab_loaded_vpn_server () {
    vpn_server=$(kubectl -n eslabs exec $(kubectl -n eslabs get pods | grep kharon | awk '{print $1}') -c expressvpn -- \
        egrep '^remote\ ' /vpn/vpn.conf | awk '{print $2}' | sed 's/-ca-version-2.expressnetw.com//g')
}
