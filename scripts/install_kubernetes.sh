#!/usr/bin/env bash

set -e

# auto install a kubernetes 3-node cluster given these 
# hostnames for either raspbian or centos platforms

# automated from:
# https://www.tecmint.com/install-a-kubernetes-cluster-on-centos-8/
# https://gist.github.com/dbafromthecold/015d87444a77e12b90433f32fb265f37

. "${ELISE_ROOT_DIR}/src/elise.env"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/os.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

ensure_root
dont_run_if_inside_docker
find_operating_system
local_k8s_node_resolution

if [ $(hostname) == "${KUBE_MASTER_NODE_HOSTNAME}" ]; then
    prepare_master_node "$operating_system"
    install_docker "$operating_system"
    install_k8s "$operating_system"
    turn_swap_off "$operating_system"

    print_message 'stdout' 'initializing k8s cluster'
    kubeadm init \
        --apiserver-advertise-address="${KUBE_MASTER_NODE_ADDRESS}" \
        --pod-network-cidr="${KUBE_CIDR_POD_NETWORK}" \
        --ignore-preflight-errors=Mem #https://github.com/kubernetes/kubeadm/issues/2365

    copy_new_kube_config "${DOCKER_USER}"

    print_message 'stdout' 'deploy flannel pod network'
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

    print_message 'stdout' 'deploy ingress controller'
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/baremetal/deploy.yaml

elif [ $(hostname) == "${KUBE_WORKER_NODE_0_HOSTNAME}" ] ||\
     [ $(hostname) == "${KUBE_WORKER_NODE_1_HOSTNAME}" ]; then
    prepare_worker_node "$operating_system"
    install_docker "$operating_system"
    install_k8s "$operating_system"
    turn_swap_off "$operating_system"

fi
