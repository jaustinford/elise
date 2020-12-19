disable_selinux () {
    if [ "$1" == 'CentOS Linux 8' ]; then
        if [ $(getenforce) != "Disabled" ]; then
            print_message 'stdout' 'disabled selinux'
            setenforce 0
            sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

        else
            print_message 'stdout' 'selinux already disabled'

        fi

    fi
}

install_docker () {
    if [ "$1" == 'Raspbian GNU/Linux 10 (buster)' ]; then
        if [ -z "$(dpkg --get-selections | grep docker-ce)" ]; then
            if [ ! -f '/boot/cmdline_backup.txt' ]; then
                print_message 'stdout' 'updating rpi cgroups'
                cp /boot/cmdline.txt /boot/cmdline_backup.txt
                orig="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
                echo ${orig} | tee /boot/cmdline.txt

                print_message 'stdout' 'rebooting host' "$(hostname)"
                reboot

            fi

            apt-get update -y
            apt-get upgrade -y
            print_message 'stdout' 'installing docker on' "$1"
            curl -sSL https://get.docker.com | sh

        fi

    elif [ "$1" == 'CentOS Linux 8' ]; then
        if [ -z "$(rpm -qa | grep docker-ce)" ]; then
            print_message 'stdout' 'installing docker on' "$1"
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
            print_message 'stdout' 'installing kubernetes on' "$1"
            curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
            echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
            apt-get install kubeadm -y
            update-alternatives --set iptables /usr/sbin/iptables-legacy

        fi

    elif [ "$1" == 'CentOS Linux 8' ]; then
        if [ -z "$(rpm -qa | grep kubeadm)" ]; then
            print_message 'stdout' 'installing kubernetes on' "$1"
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
    if [ "$1" == 'CentOS Linux 8' ]; then
        if [ "$(cat /proc/sys/net/bridge/bridge-nf-call-iptables 2> /dev/null)" == "1" ]; then
            print_message 'stdout' 'configuring bridge adapter settings'
            modprobe br_netfilter
            echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

        fi
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

prepare_master_node () {
    print_message 'stdout' 'preparing master' "$(hostname)"
    if [ "$1" == 'CentOS Linux 8' ]; then
        disable_selinux "$operating_system"
        print_message 'stdout' 'adding k8s firewalld'
        firewall-cmd --permanent --add-port=6443/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=2379-2380/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=10250/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=10251/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=10252/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=10255/tcp 1> /dev/null
        firewall-cmd --reload 1> /dev/null
        modprobe_br_netfilter "$operating_system"

    fi
}

prepare_worker_node () {
    print_message 'stdout' 'preparing worker' "$(hostname)"
    if [ "$1" == 'CentOS Linux 8' ]; then
        disable_selinux "$operating_system"
        print_message 'stdout' 'adding k8s firewalld'
        firewall-cmd --permanent --add-port=6783/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=10250/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=10255/tcp 1> /dev/null
        firewall-cmd --permanent --add-port=30000-32767/tcp 1> /dev/null
        firewall-cmd --reload 1> /dev/null
        modprobe_br_netfilter "$operating_system"

    fi
}

install_open_iscsi () {
    if [ "$1" == 'CentOS Linux 8' ]; then
        if [ -z "$(rpm -qa | grep iscsi-initiator-utils)" ]; then
            print_message 'stdout' 'installing iscsi tools'
            yum install -y iscsi-initiator-utils

        fi

    fi
}

install_ntopng () {
    if [ "$1" == 'Raspbian GNU/Linux' ]; then
        if [ -z "$(which ntopng 2> /dev/null)" ]; then
            print_message 'stdout' 'installing repo' "$2"
            wget "http://packages.ntop.org/RaspberryPI/$2" 1> /dev/null
            dpkg -i "$2" 1> /dev/null

            for pkg in ntopng nrpobe n2n; do
                print_message 'stdout' 'installing package' "$pkg"
                apt install "$pkg" -y 1> /dev/null

            done

        fi
    fi
}

print_rpi_temp () {
    if [ "$1" == "Raspbian GNU/Linux 10 (buster)" ]; then
        while true; do
            temp_c=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
            temp_f=$(echo $temp_c*9/5+32 | bc -l)
            print_message 'stdout' "$(date +%Y.%m.%d-%H:%M:%S) - $(echo $temp_f | egrep -o '[0-9]{1,}[.][0-9]{2}') degrees fahrenheit"
            sleep 4

        done

    fi
}

install_v4l2rtspserver () {
    if [ "$1" == "Raspbian GNU/Linux 10 (buster)" ]; then
        if [ -z $(which v4l2rtspserver) ]; then
            print_message 'stdout' 'installing v4l2rtspserver'
            apt update -y
            apt install -y git cmake
            git clone https://github.com/mpromonet/v4l2rtspserver.git
            cd v4l2rtspserver
            cmake .
            make
            make install
            apt-get install -y \
                v4l-utils \
                uvcdynctrl

        fi

    fi
}
