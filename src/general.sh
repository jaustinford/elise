print_message () {
    TOTAL_LENGTH='30'
    KEY_LENGTH=$(echo "$2" | wc -c)
    PAD_LENGTH=$(echo $TOTAL_LENGTH-$KEY_LENGTH | bc -l)

    key="$2"
    for pad in $(seq 1 $PAD_LENGTH); do
        key+=" "

    done

    if [ "$1" == 'stdout' ]; then
        if [ ! -z "$3" ]; then
            echo -e "[$SHELL_STDOUT_CODE OK $ECHO_RESET] $key | $3"

        else
            echo -e "[$SHELL_STDOUT_CODE OK $ECHO_RESET] $key"

        fi

    elif [ "$1" == 'stderr' ]; then
        echo -e "[$SHELL_STDERR_CODE ERROR $ECHO_RESET] $key"

    fi
}

sed_edit () {
    print_message 'stdout' "switching $1" "$2"
    for file in $(grep -R --exclude-dir=.git "$1" . | cut -d':' -f1); do
        sed -i "s/$1/$2/g" "$file"

    done
}

find_operating_system () {
    operating_system=$(cat /etc/os-release \
        | grep PRETTY_NAME \
        | cut -d'=' -f2 \
        | sed 's/"//g')
}

dont_run_if_inside_docker () {
    if [ ! -z "$(cat /proc/1/cgroup | grep \/docker\/)" ]; then
        print_message 'stderr' 'cant run from inside container'
        exit 1

    fi
}

ensure_root () {
    if [ $(whoami) != "root" ]; then
        print_message 'stderr' 'must be run as root'
        exit 1

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
