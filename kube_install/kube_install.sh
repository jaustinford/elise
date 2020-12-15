#!/usr/bin/env bash

set -e

# auto install a kubernetes 3-node cluster given these 
# hostnames for either raspbian or centos platforms

# automated from:
# https://www.tecmint.com/install-a-kubernetes-cluster-on-centos-8/
# https://gist.github.com/dbafromthecold/015d87444a77e12b90433f32fb265f37

. /mnt/tvault/es-labs/projects/es-labs-scripts/vars/eslabs.ini
. "${SCRIPTS_DIR}/echo_colors.sh"
. "${KUBE_INSTALL_SCRIPTS}/os.sh"

KUBE_REPO='[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'

etc_hosts () {
    # ensure host resolution entries for each cluster node
    # are present in local /etc/hosts
    echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] updating /etc/hosts"
    if [ -z "$(cat /etc/hosts | egrep ^${KUBE_MASTER_NODE_ADDRESS})" ]; then
        echo "${KUBE_MASTER_NODE_ADDRESS}    ${KUBE_MASTER_NODE_HOSTNAME}" >> /etc/hosts

    fi
    if [ -z "$(cat /etc/hosts | egrep ^${KUBE_WORKER_NODE_0_ADDRESS})" ]; then
        echo "${KUBE_WORKER_NODE_0_ADDRESS}    ${KUBE_WORKER_NODE_0_HOSTNAME}" >> /etc/hosts

    fi
    if [ -z "$(cat /etc/hosts | egrep ^${KUBE_WORKER_NODE_1_ADDRESS})" ]; then
        echo "${KUBE_WORKER_NODE_1_ADDRESS}    ${KUBE_WORKER_NODE_1_HOSTNAME}" >> /etc/hosts

    fi
}

bridge_centos () {
    if [ "$(cat /proc/sys/net/bridge/bridge-nf-call-iptables 2> /dev/null)" == "1" ]; then
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] configuring bridge adapter settings"
        modprobe br_netfilter
        echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

    fi
}

swap () {
    if [ -n "$(cat /proc/swaps | grep -v Filename)" ]; then
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] disabling swap"
        chmod +x /etc/rc.d/rc.local
        echo "swapoff -a" >> /etc/rc.d/rc.local
        swapoff -a

    fi
}

master_node () {
    if [ "${OS_NAME}" == "Raspbian GNU/Linux" ]; then
        # cgroups
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] updating rpi cgroups..."
        cp /boot/cmdline.txt /boot/cmdline_backup.txt
        orig="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
        echo ${orig} | tee /boot/cmdline.txt

        # install
        install_docker_rpi
        install_k8s_rpi

    elif [ "${OS_NAME}" == "CentOS Linux" ]; then
        # disable selinux
        selinux

        # firewalld rules
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] adding kubernetes firewalld rules..."
        firewall-cmd --permanent --add-port=6443/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=2379-2380/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=10250/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=10251/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=10252/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=10255/tcp 1> /dev/null
        firewall-cmd --reload 1> /dev/null

        # networking
        bridge_centos

        # install
        install_docker_centos
        install_k8s_centos

    fi

    swap
}

worker_node () {
    if [ "${OS_NAME}" == "CentOS Linux" ]; then
        # disable selinux
        selinux

        # firewalld rules
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] adding kubernetes firewalld rules..."
        firewall-cmd --permanent --add-port=6783/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=10250/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=10255/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=30000-32767/tcp 1> /dev/null
        firewall-cmd --reload 1> /dev/null

        # networking
        bridge_centos

        # install
        install_docker_centos
        install_k8s_centos

    fi

    swap
}

setup_k8s () {
    if [ ! -f "${HOME}/.kube/config" ]; then
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] copying configuration"
        mkdir -p "${HOME}/.kube"
        cp -i /etc/kubernetes/admin.conf "${HOME}/.kube/config"
        chown $(id -u):$(id -g) "${HOME}/.kube/config"

    fi
}

ensure_root

etc_hosts

if [ $(hostname) == "${KUBE_MASTER_NODE_HOSTNAME}" ]; then
    echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] preparing master node : $(hostname)"
    master_node

    echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] initializing kubernetes cluster"
    kubeadm init \
        --apiserver-advertise-address="${KUBE_MASTER_NODE_ADDRESS}" \
        --pod-network-cidr="${KUBE_CIDR_POD_NETWORK}" \
        --service-cidr="${KUBE_CIDR_SERVICE}"

    echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] configuring local config"
    setup_k8s

    echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] deploying flannel pod network"
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

    echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] deploying nginx ingress controller"
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/baremetal/deploy.yaml

elif [ $(hostname) == "${KUBE_WORKER_NODE_0_HOSTNAME}" ] ||\
     [ $(hostname) == "${KUBE_WORKER_NODE_1_HOSTNAME}" ]; then
    echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] preparing worker node : $(hostname)"
    worker_node

fi
