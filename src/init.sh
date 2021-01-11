ssh_key () {
    print_message 'stdout' 'configure user ssh key' '/tmp/id_rsa'
    echo "${LAB_USER_AUSTIN_SSH_KEY}" | base64 -d > /tmp/id_rsa
    chmod 600 /tmp/id_rsa
}

ssh_client_config () {
    print_message 'stdout' 'configure client ssh config' '/tmp/ssh_config'
    cat <<EOF > /tmp/ssh_config
Host kube0* dns
    User ubuntu

Host watcher0* wrkstn
    User austin

Host netmon
    User pi

Host tvault
    User sshd

Host labs.elysianskies.com
    User ubuntu
    Port 6945
EOF
    chmod 600 /tmp/ssh_config
}

add_local_dns_search () {
    print_message 'stdout' 'generating local dns search' "$1"
    if [ -z "$(grep $1 /etc/resolv.conf)" ]; then
        echo "search $1" >> /etc/resolv.conf

    fi
}

check_cluster_from_wan_connectivity () {
    if [ $(nmap -p $1 ${LAB_FQDN} | egrep "^$1\/(udp|tcp)" | awk '{print $2}') == 'open' ]; then
        print_message 'stdout' 'lab wan connection confirmed' "${LAB_FQDN}:$1"

    else
        print_message 'stderr' 'lab wan connection refused' "${LAB_FQDN}:$1"

    fi
}
