ssh_key () {
    print_message 'stdout' 'configure user ssh key' '/tmp/id_rsa'
    echo "${AUSTIN_SSH_KEY}" | base64 -d > /tmp/id_rsa
    chmod 600 /tmp/id_rsa
}

ssh_client_config () {
    print_message 'stdout' 'configure client ssh config' '/tmp/id_rsa'
    cat <<EOF > /tmp/ssh_config
Host netmon kube0* watcher* dns wrkstn *.labs.elysianskies.com
    User austin

Host tvault
    User sshd

Host labs.elysianskies.com
    User austin
    Port 6945
EOF
    chmod 600 /tmp/ssh_config
}

check_cluster_to_wan_connectivity () {
    if [ $(nmap -p 6443 ${LAB_FQDN} | egrep '^6443\/tcp' | awk '{print $2}') == 'open' ]; then
        print_message 'stdout' 'lab wan connection confirmed' "${LAB_FQDN}:6443"

    else
        print_message 'stderr' 'lab wan connection refused' "${LAB_FQDN}:6443"

    fi
}
