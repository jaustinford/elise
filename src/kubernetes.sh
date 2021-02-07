kube_config () {
    print_message 'stdout' 'generating kubernetes config' "$1/.kube/config"
    mkdir -p "$1/.kube"
    echo "${KUBE_CONFIG_FILE}" | base64 -d > "$1/.kube/config"
}

ensure_kubeconfig () {
    if [ ! -f ~/.kube/config ]; then
        print_message 'stderr' 'missing ~/.kube/config'
        exit 1

    fi
}

kube_nodes () {
    kubectl get nodes -o wide
}

wait_for_pod_to () {
    if [ "$1" == 'start' ]; then
        while [ "$(kubectl get pods --all-namespaces | grep $2 | awk '{print $4}')" != 'Running' ]; do
            sleep 2

        done

    elif [ "$1" == 'stop' ]; then
        while [ ! -z "$(kubectl get pods --all-namespaces | grep $2 | egrep '\-[a-z0-9]{1,}\-[a-z0-9]{1,}')" ]; do
            sleep 2

        done

    fi
}

kube_start_deployment () {
    print_message 'stdout' "deploy pods ($3)" "$1/$2"
    kubectl -n "$1" scale --replicas="$3" deployment/"$2" 1> /dev/null
}

kube_stop_deployment () {
    print_message 'stdout' 'delete pods' "$1/$2"
    kubectl -n "$1" scale --replicas=0 deployment/"$2" 1> /dev/null
}

check_if_k8s_is_using () {
    if [ ! -z "$(kubectl describe pod --all-namespaces | egrep "from\ $1\ \(r(w|o)\)")" ]; then
        print_message 'stderr' 'cant proceed while kubernetes has volume'
        exit 1

    fi
}

find_namespace_from_deployment () {
    namespace=$(kubectl get deployments --all-namespaces \
        | grep "$1" \
        | awk '{print $1}')
}

find_deployments_from_array () {
    iscsi_backup_volumes=("$@")
        for vol in "${iscsi_backup_volumes[@]}"; do
            deployment=$(kubectl describe pods --all-namespaces \
                | egrep "^Name\:|$vol" \
                | egrep "$vol\ \(r(o|w)\)$" -B1 \
                | egrep '^Name\:' \
                | awk '{print $2}' \
                | sed -E 's/\-[0-9a-z]{1,}\-[0-9a-z]{1,}$//g')

                attached_deployments+=("$deployment")

        done

        unique_deployments=$(echo "${attached_deployments[@]}" | tr ' ' '\n' | sort -u)
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

kube_get () {
    kubectl -n "$1" -o wide get "$2"
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
    if [ ! -z "$3" ]; then
        kubectl -n "$1" exec --stdin --tty \
            "$(kubectl -n $1 get pods | grep $2 | awk '{print $1}')" -c "$3" -- "$4"

    else
        kubectl -n "$1" exec --stdin --tty \
            "$(kubectl -n $1 get pods | grep $2 | awk '{print $1}')" -- "$4"

    fi
}

kube_edit () {
    kubectl -n "$1" edit "$2" "$3"
}

kube_describe () {
    if [ "$2" == "pod" ]; then
        kubectl -n "$1" describe "$2" $(kubectl -n $1 get pods | grep $3 | awk '{print $1}')

    else
        kubectl -n "$1" describe "$2" "$3"

    fi
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
