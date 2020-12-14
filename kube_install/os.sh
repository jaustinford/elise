#!/usr/bin/env bash

set -e

. /mnt/tvault/es-labs/projects/es-labs-scripts/vars/eslabs.env
. "${SCRIPTS_DIR}/echo_colors.sh"

# collection of functions and key values specific to centos and
# raspbian configurations

OS_NAME=$(cat /etc/os-release | egrep ^NAME | sed 's/"//g' | cut -d'=' -f2)

SYSTEMD_DRIVER='{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}'

ensure_root () {
    if [ $(whoami) != "root" ]; then
        echo "[$DEFAULT_STDERR_COLOR*$ECHO_RESET] must be run as root!"
        exit 1

    fi
}

selinux () {
    if [ $(getenforce) != "Disabled" ]; then
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] disabled selinux, rebooting..."
        sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
        reboot

    else
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] selinux already disabled."

    fi
}

docker_systemd_driver () {
    if [ -z "$(grep '"log-driver": "json-file",' /etc/docker/daemon.json)" ]; then
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] configuring docker systemd driver"
        mkdir -p /etc/docker
        echo "${SYSTEMD_DRIVER}" > /etc/docker/daemon.json
        mkdir -p /etc/systemd/system/docker.service.d
        systemctl daemon-reload
        systemctl restart docker
    fi
}

install_docker_centos () {
    if [ -z "$(rpm -qa | grep docker-ce)" ]; then
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] installing docker on ${OS_NAME}"
        yum update -y
        yum upgrade -y
        dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
        dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm -y
        dnf install docker-ce -y
        usermod -aG docker "${DOCKER_USER}"
        systemctl enable docker
        systemctl start docker
        docker_systemd_driver
    fi
}

install_docker_rpi () {
    if [ -z "$(dpkg --get-selections | grep docker-ce)" ]; then
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] installing docker on ${OS_NAME}"
        apt-get update -y
        apt-get upgrade -y
        curl -sSL https://get.docker.com | sh
        usermod -aG docker "${DOCKER_USER}"
        systemctl enable docker
        systemctl start docker
        docker_systemd_driver
    fi
}

install_k8s_centos () {
    if [ -z "$(rpm -qa | grep kubeadm)" ]; then
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] installing kubernetes on ${OS_NAME}"
        apt-get update -y
        echo "${KUBE_REPO}" > /etc/yum.repos.d/kubernetes.repo
        dnf install kubeadm -y
        systemctl enable kubelet
        systemctl start kubelet
    fi
}

install_k8s_rpi () {
    if [ -z "$(dpkg --get-selections | grep kubeadm)" ]; then
        echo "[$DEFAULT_STDOUT_COLOR*$ECHO_RESET] installing kubernetes on ${OS_NAME}"
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
        apt-get install kubeadm -y
        update-alternatives --set iptables /usr/sbin/iptables-legacy
        systemctl enable kubelet
        systemctl start kubelet
    fi
}
