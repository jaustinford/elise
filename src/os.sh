disable_selinux () {
    if [ $(getenforce) != "Disabled" ]; then
        print_message 'stdout' 'disabled selinux'
        setenforce 0
        sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

    else
        print_message 'stdout' 'selinux already disabled'

    fi
}

docker_systemd_driver () {
    if [ -z "$(grep '"log-driver": "json-file",' /etc/docker/daemon.json)" ]; then
        print_message 'stdout' 'configuring docker systemd driver'
        mkdir -p /etc/docker
        cat <<EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
        mkdir -p /etc/systemd/system/docker.service.d
        systemctl daemon-reload
        systemctl restart docker

    fi
}

install_docker () {
    if [ "$1" == 'Raspbian GNU/Linux 10 (buster)' ]; then
        if [ -z "$(dpkg --get-selections | grep docker-ce)" ]; then
            print_message 'stdout' "installing docker on ${operating_system}"
            apt-get update -y
            apt-get upgrade -y
            curl -sSL https://get.docker.com | sh

        fi

    elif [ "$1" == 'CentOS Linux 8' ]; then
        if [ -z "$(rpm -qa | grep docker-ce)" ]; then
            print_message 'stdout' "installing docker on ${operating_system}"
            yum update -y
            yum upgrade -y
            dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
            dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm -y
            dnf install docker-ce -y

        fi

    fi

    usermod -aG docker "${DOCKER_USER}"
    systemctl enable docker 1> /dev/null
    systemctl start docker 1> /dev/null
    docker_systemd_driver
}

install_k8s () {
    if [ "$1" == 'Raspbian GNU/Linux 10 (buster)' ]; then
        if [ -z "$(dpkg --get-selections | grep kubeadm)" ]; then
            print_message 'stdout' "installing kubernetes on ${operating_system}"
            curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
            echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
            apt-get install kubeadm -y
            update-alternatives --set iptables /usr/sbin/iptables-legacy

        fi

    elif [ "$1" == 'CentOS Linux 8' ]; then
        if [ -z "$(rpm -qa | grep kubeadm)" ]; then
            print_message 'stdout' "installing kubernetes on ${operating_system}"
            apt-get update -y
            cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
            dnf install kubeadm -y

        fi

    fi

    systemctl enable kubelet
    systemctl start kubelet
}

modprobe_br_netfilter () {
    if [ "$(cat /proc/sys/net/bridge/bridge-nf-call-iptables 2> /dev/null)" == "1" ]; then
        print_message 'stdout' 'configuring bridge adapter settings'
        modprobe br_netfilter
        echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

    fi
}

turn_swap_off () {
    if [ -n "$(cat /proc/swaps | grep -v Filename)" ]; then
        print_message 'stdout' 'disabling swap'
        chmod +x /etc/rc.d/rc.local
        echo "swapoff -a" >> /etc/rc.d/rc.local
        swapoff -a

    fi
}
