#!/usr/bin/env bash

set -eu

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
local_k8s_node_resolution

if [ $(hostname) == "${KUBE_MASTER_NODE_HOSTNAME}" ]; then
    install_master_node

    print_message 'stdout' 'initializing k8s cluster'
    kubeadm init \
        --apiserver-advertise-address="${KUBE_MASTER_NODE_ADDRESS}" \
        --pod-network-cidr="${KUBE_CIDR_POD_NETWORK}" \
        --service-cidr="${KUBE_CIDR_SERVICE}"

    copy_new_kube_config

    print_message 'stdout' 'deploy flannel pod network'
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

    print_message 'stdout' 'deploy ingress controller'
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/baremetal/deploy.yaml

elif [ $(hostname) == "${KUBE_WORKER_NODE_0_HOSTNAME}" ] ||\
     [ $(hostname) == "${KUBE_WORKER_NODE_1_HOSTNAME}" ]; then
    install_worker_node

fi
