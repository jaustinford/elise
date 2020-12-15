check_if_k8s_is_using () {
    if [ ! -z "$(kubectl describe pod --all-namespaces | egrep "from\ $1\ \(r(w|o)\)")" ]; then
        print_message 'stderr' 'cant proceed while kubernetes has volume'
        exit 1

    fi
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

find_namespace_from_deployment () {
    namespace=$(kubectl get deployments --all-namespaces \
        | grep "$1" \
        | awk '{print $1}')
}

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

      namespace : $3 $1 $ECHO_RESET

$3    nodes     $ECHO_RESET

$(kubectl get nodes -o wide)

$3    pods      $ECHO_RESET

$(kubectl -n $1 -o wide get pods)

$3    services  $ECHO_RESET

$(kubectl -n $1 -o wide get services)

$3    endpoints $ECHO_RESET

$(kubectl -n $1 -o wide get endpoints)

$3    ingresses $ECHO_RESET

$(kubectl -n $1 -o wide get ingresses)

$3    events    $ECHO_RESET

$(kubectl -n $1 -o wide get events)
"
}

kube_exec () {
    if [ ! -z "$4" ]; then
        kubectl -n "$1" exec --stdin --tty \
            "$(kubectl -n $1 get pods | grep $2 | awk '{print $1}')" -c "$4" -- /bin/sh -c "$3"

    else
        kubectl -n "$1" exec --stdin --tty \
            "$(kubectl -n $1 get pods | grep $2 | awk '{print $1}')" -- /bin/sh -c "$3"

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
    print_message 'stdout' 'generating kubernetes config' "${SHELL_ROOT_DIR}/.kube/config"
    mkdir -p "${SHELL_ROOT_DIR}/.kube"
    echo "${KUBE_CONFIG_FILE}" | base64 -d > "${SHELL_ROOT_DIR}/.kube/config"
}
