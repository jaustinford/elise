####################################################
# kubectl wrapper
####################################################

kube_start_deployment () {
    namespace="$1"
    deployment="$2"
    replicas="$3"

    kubectl -n "$namespace" scale "--replicas=$replicas" "deployment/$deployment"
}

kube_stop_deployment () {
    namespace="$1"
    deployment="$2"

    kubectl -n "$namespace" scale --replicas=0 "deployment/$deployment"
}

kube_nodes () {
    kubectl get nodes -o wide
}

kube_get () {
    namespace="$1"
    resource="$2"

    kubectl -n "$namespace" -o wide get "$resource"
}

kube_exec () {
    namespace="$1"
    pod="$2"
    container="$3"
    command="$4"

    kubectl -n "$namespace" exec --stdin --tty "$pod" -c "$container" -- /bin/bash -c "$command"
}

kube_edit () {
    namespace="$1"
    resource="$2"
    object="$3"

    kubectl -n "$namespace" edit "$resource" "$object"
}

kube_describe () {
    namespace="$1" 
    resource="$2"
    object="$3"

    kubectl -n "$namespace" describe "$resource" "$object"
}

kube_logs_deployment () {
    namespace="$1"
    deployment="$2"
    container="$3"

    kubectl -n "$namespace" logs "deployment/$deployment" -c "$container"
}

kube_tail_deployment () {
    namespace="$1"
    deployment="$2"
    container="$3"

    kubectl -n "$namespace" logs -f --tail=50 "deployment/$deployment" -c "$container"
}

####################################################
# kubeconfig
####################################################

kube_config () {
    home_dir="$1"
    apiserver_domain="$2"

    print_message stdout 'generate kubernetes config' "https://$apiserver_domain:6443"
    mkdir -p "$home_dir/.kube"
    cat <<EOF > "$home_dir/.kube/config"
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${KUBE_CONFIG_CERTIFICATE_AUTHORITY_DATA}
    server: https://$apiserver_domain:6443
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

    chmod 600 "$home_dir/.kube/config"
}

####################################################
# pod determination
####################################################

pod_from_deployment () {
    namespace="$1"
    app="$2"
    wait="$3"

    if [ "$wait" == 'wait' ]; then
        while [ -z "$(kubectl -n "$namespace" get pods -o json \
            | jq -r ".items[] | select (.metadata.labels.app == \"$app\") | .metadata.name")" ]; do
            sleep 1

        done

    fi

    kubectl -n "$namespace" get pods -o json \
        | jq -r ".items[] | select (.metadata.labels.app == \"$app\") | .metadata.name"
}

pods_from_namespace () {
    namespace="$1"

    kubectl -n "$namespace" get pods -o json \
        | jq -r ".items[].metadata.name"
}

pods_from_regex () {
    namespace="$1"
    regex_string="$2"

    kubectl -n "$namespace" get pods -o json \
        | jq -r ".items[] | select (.metadata.name | test(\"$regex_string\")) | .metadata.name"
}

####################################################
# pod states
####################################################

ensure_pod () {
    pod_mode="$1"
    namespace="$2"
    pod="$3"

    print_message stdout 'ensuring pod state' "$pod_mode - $namespace/$pod"
    if [ "$pod_mode" == 'start' ]; then
        while [ "$(kubectl -n "$namespace" get pods -o json \
            | jq -r ".items[] | select (.metadata.name == \"$pod\") | .status.phase")" != 'Running' ] && \
              [ "$(kubectl -n "$namespace" get pods -o json \
            | jq -r ".items[] | select (.metadata.name == \"$pod\") | .status.phase")" != 'Succeeded' ]; do
            sleep 1

        done

        print_message stdout "pod is '$(kubectl -n "$namespace" get pods -o json \
            | jq -r ".items[] | select (.metadata.name == \"$pod\") | .status.phase")'"

    elif [ "$pod_mode" == 'stop' ]; then
        while [ ! -z "$(kubectl -n "$namespace" get pods -o json \
            | jq -r ".items[] | select (.metadata.name == \"$pod\") | .metadata.name")" ]; do
            sleep 1

        done

        print_message stdout 'pod is gone'

    fi
}

ensure_pods () {
    pod_mode="$1"
    namespace="$2"

    for item in $(pods_from_namespace "$namespace"); do
        ensure_pod "$pod_mode" "$namespace" "$item"

    done
}

####################################################
# kube display
####################################################

kube_display () {
    namespace="$1"
    color_1="$2"
    color_2="$3"

    echo -e "

$color_1    ${KUBE_DISPLAY_BANNER}                                   $ECHO_RESET

      namespace : $color_2 $namespace                                $ECHO_RESET

$color_2  nodes                                                      $ECHO_RESET

$(kube_get $namespace nodes)

$color_2  pods                                                       $ECHO_RESET

$(kube_get $namespace pods)

$color_2  services                                                   $ECHO_RESET

$(kube_get $namespace services)

$color_2  endpoints                                                  $ECHO_RESET

$(kube_get $namespace endpoints)

$color_2  ingresses                                                  $ECHO_RESET

$(kube_get $namespace ingresses)
"
}

####################################################
# error handles
####################################################

ensure_kubeconfig () {
    if [ ! -f ~/.kube/config ]; then
        print_message stderr 'missing ~/.kube/config'
        exit 1

    fi
}

check_if_k8s_is_using () {
    volume_name="$1"

    if [ ! -z "$(kubectl get pods --all-namespaces -o json \
        | jq -r ".items[].spec.containers[].volumeMounts[] | select (.name == \"$volume_name\") | .name")" ]; then
        print_message stderr 'cant proceed while kubernetes has volume'
        exit 1

    fi
}

####################################################
# soteria
####################################################

find_active_deployments_from_array () {
    deployments=()
    active_deployments=()

    for vol in "${ISCSI_BACKUP_VOLUMES[@]}"; do
        deployments+=($(kubectl get pods --all-namespaces -o json \
            | jq -r ".items[] | select (.spec.containers[].volumeMounts[].name == \"$vol\") | .metadata.labels.app"))

    done

    for item in $(echo "${deployments[@]}" | tr ' ' '\n' | sort -u); do
        active_deployments+=("$item")

    done
}

find_volumes_from_active_deployment () {
    active_deployment="$1"

    all_volumes=()
    active_volumes=()
    all_volumes+=($(kubectl get pods --all-namespaces -o json \
        | jq -r ".items[] | select (.metadata.labels.app == \"$active_deployment\") | .spec.volumes[] | select (.iscsi.targetPortal == \"${ISCSI_PORTAL}\") | .name"))

    for vol in "${ISCSI_BACKUP_VOLUMES[@]}"; do
        for item in "${all_volumes[@]}"; do
            if [ "$vol" == "$item" ]; then
                active_volumes+=("$item")

            fi

        done

    done
}

####################################################
# pod-executed shell
####################################################

crash_container () {
    namespace="$1"
    pod="$2"
    container="$3"

    # meant as a way to force kubernetes to restart containers by crashing them internally
    # as opposed to using kubernetes to kill the pod. useful in troubleshooting boot order
    # issues with pods that have multiple containers.
    print_message stdout 'crashing container' "$namespace/$pod:$container"
    kube_exec "$namespace" "$pod" "$container" /sbin/killall5
}

grab_loaded_vpn_server () {
    kharon_pod="$1"

    if [ ! -z "$kharon_pod" ]; then
        loaded_vpn_server="$(kube_exec eslabs "$kharon_pod" expressvpn "egrep ^remote\  /vpn/vpn.conf \
            | awk '{print \$2}' \
            | sed 's/-ca-version-2.expressnetw.com//g'")"

        loaded_vpn_server="$(echo "$loaded_vpn_server" | sed 's/\r$//g')"
        print_message stdout 'expressvpn connected' "$loaded_vpn_server"

    else
        print_message stderr 'expressvpn not connected' "${KHARON_EXPRESSVPN_SERVER}"

    fi
}

find_wan_from_pod () {
    kharon_pod="$1"

    if [ ! -z "$kharon_pod" ]; then
        pod_wan="$(kube_exec eslabs "$kharon_pod" expressvpn 'curl -s ifconfig.me')"
        print_message stdout 'expressvpn wan ip' "$pod_wan"

    else
        print_message stderr 'wan ip exposed' "$(curl -s ifconfig.me)"

    fi
}

display_tvault_stats () {
    plex_pod="$1"

    if [ ! -z "$plex_pod" ]; then
        tdata="$(kube_exec eslabs $plex_pod plexserver "df -H | egrep ^//${ISCSI_PORTAL}/tvault")"
        full="$(echo "$tdata" | awk '{print $2}')"
        used="$(echo "$tdata" | awk '{print $3}')"
        avail="$(echo "$tdata" | awk '{print $4}')"
        perc="$(echo "$tdata" | awk '{print $5}')"
        print_message stdout 'tvault volume statistics' "total $full - available $avail - used $used ($perc)"

    else
        print_message stderr 'cant pull from plex pod for tvault volume statistics'

    fi
}
