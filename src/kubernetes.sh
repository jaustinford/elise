####################################################
# kubectl wrapper
####################################################

kube_start_deployment () {
    kubectl -n $1 scale --replicas=$3 deployment/$2
}

kube_stop_deployment () {
    kubectl -n $1 scale --replicas=0 deployment/$2
}

kube_nodes () {
    kubectl get nodes -o wide
}

kube_get () {
    kubectl -n $1 -o wide get $2
}

kube_exec () {
    kubectl -n $1 exec --stdin --tty $2 -c $3 -- /bin/bash -c "$4"
}

kube_edit () {
    kubectl -n $1 edit $2 $3
}

kube_describe () {
    kubectl -n $1 describe $2 $3
}

kube_logs_deployment () {
    kubectl -n $1 logs deployment/$2 -c $3
}

kube_tail_deployment () {
    kubectl -n $1 logs -f --tail=50 deployment/$2 -c $3
}

####################################################
# kubeconfig
####################################################

kube_config () {
    print_message 'stdout' 'generate kubernetes config' "https://${LAB_FQDN}:6443"
    mkdir -p "$1/.kube"
    cat <<EOF > "$1/.kube/config"
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${KUBE_CONFIG_CERTIFICATE_AUTHORITY_DATA}
    server: https://${LAB_FQDN}:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: ${KUBE_CONFIG_CLIENT_CERTIFICATE_DATA}
    client-key-data: ${KUBE_CONFIG_CLIENT_KEY_DATA}
EOF
}

####################################################
# pod power cycling
####################################################

pod_from_deployment () {
    if [ "$3" == 'wait' ]; then
        while [ -z $(kubectl get pods --all-namespaces -o json \
            | jq -r ".items[] | select(.metadata.labels.app == \"$2\") | .metadata.name") ]; do
            sleep 1

        done

    fi

    pod=$(kubectl get pods --all-namespaces -o json \
        | jq -r ".items[] | select(.metadata.labels.app == \"$2\") | .metadata.name")
}

wait_for_pod_to () {
    if [ "$1" == 'start' ]; then
        print_message 'stdout' 'deploying pod' "$2/$3"
        while [ $(kubectl -n $2 get pods -o json \
            | jq -r ".items[] | select(.metadata.name == \"$3\") | .status.phase") != 'Running' ]; do
            sleep 1

        done

    elif [ "$1" == 'stop' ]; then
        print_message 'stdout' 'terminating pod' "$2/$3"
        while [ ! -z $(kubectl -n $2 get pods -o json \
            | jq -r ".items[] | select(.metadata.name == \"$3\") | .metadata.name") ]; do
            sleep 1

        done

    fi
}

####################################################
# kube display
####################################################

kube_display () {
    echo -e "

$2    ${KUBE_DISPLAY_BANNER}                                   $ECHO_RESET

      namespace : $3 $1                                        $ECHO_RESET

$3  nodes                                                      $ECHO_RESET

$(kube_get $1 nodes)

$3  pods                                                       $ECHO_RESET

$(kube_get $1 pods)

$3  services                                                   $ECHO_RESET

$(kube_get $1 services)

$3  endpoints                                                  $ECHO_RESET

$(kube_get $1 endpoints)

$3  ingresses                                                  $ECHO_RESET

$(kube_get $1 ingresses)
"
}

####################################################
# error handles
####################################################

ensure_kubeconfig () {
    if [ ! -f ~/.kube/config ]; then
        print_message 'stderr' 'missing ~/.kube/config'
        exit 1

    fi
}

check_if_k8s_is_using () {
    if [ ! -z $(kubectl get pods --all-namespaces -o json \
        | jq -r ".items[].spec.containers[].volumeMounts[] | select (.name == \"$1\") | .name") ]; then
        print_message 'stderr' 'cant proceed while kubernetes has volume'
        exit 1

    fi
}

####################################################
# lab_backup
####################################################

find_active_deployments_from_array () {
    active_deployments=()

    for vol in "${ISCSI_BACKUP_VOLUMES[@]}"; do
        active_deployments+=($(kubectl get pods --all-namespaces -o json \
            | jq -r ".items[] | select (.spec.containers[].volumeMounts[].name == \"$vol\") | .metadata.labels.app"))

    done

    deployments=$(echo "${active_deployments[@]}" | tr ' ' '\n' | sort -u)
}

find_volumes_from_active_deployment () {
    all_volumes=()
    volumes=()

    all_volumes+=($(kubectl get pods --all-namespaces -o json \
        | jq -r ".items[] | select (.metadata.labels.app == \"$1\") | .spec.volumes[] | select (.iscsi.targetPortal == \"${ISCSI_PORTAL}\") | .name"))

    for vol in "${ISCSI_BACKUP_VOLUMES[@]}"; do
        for item in "${all_volumes[@]}"; do
            if [ "$vol" == "$item" ]; then
                volumes+=("$item")

            fi

        done

    done
}

####################################################
# pod-executed shell
####################################################

crash_container () {
    # meant as a way to force kubernetes to restart containers by crashing them internally
    # as opposed to using kubernetes to kill the pod. useful in troubleshooting boot order
    # issues with pods that have multiple containers.
    print_message 'stdout' 'crashing container' "$1/$2:$3"
    kube_exec "$1" "$2" "$3" '/sbin/killall5'
}

grab_loaded_vpn_server () {
    loaded_vpn_server=$(kube_exec 'eslabs' $1 'expressvpn' "egrep ^remote\  /vpn/vpn.conf \
        | awk '{print \$2}' \
        | sed 's/-ca-version-2.expressnetw.com//g'")

    loaded_vpn_server=$(echo "$loaded_vpn_server" | sed 's/\r//g')

    if [ ! -z "$loaded_vpn_server" ]; then
        print_message 'stdout' 'expressvpn connected' "$loaded_vpn_server"

    else
        print_message 'stderr' 'expressvpn not connected' "${KHARON_EXPRESSVPN_SERVER}"

    fi
}

find_wan_from_pod () {
    pod_wan=$(kube_exec 'eslabs' $1 'expressvpn' 'curl -s checkip.amazonaws.com')

    if [ ! -z "$pod_wan" ]; then
        print_message 'stdout' 'expressvpn wan ip' "$pod_wan"

    else
        print_message 'stderr' 'wan ip exposed' "$(curl -s checkip.amazonaws.com)"

    fi
}

display_tvault_stats () {
    tdata=$(kube_exec 'eslabs' $1 'plexserver' "df -h | egrep ^//${ISCSI_PORTAL}/tvault")
    full=$(echo "$tdata" | awk '{print $2}')
    used=$(echo "$tdata" | awk '{print $3}')
    avail=$(echo "$tdata" | awk '{print $4}')
    perc=$(echo "$tdata" | awk '{print $5}')

    if [ ! -z "$full" ]; then
        print_message 'stdout' 'tvault volume statistics' "size $full - avail $avail - used $used ($perc)"

    else
        print_message 'stderr' 'cant pull from plex pod for tvault volume statistics'

    fi
}
