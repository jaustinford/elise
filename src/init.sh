ssh_key () {
    print_message 'stdout' 'configure user ssh key'
    echo "${AUSTIN_SSH_KEY}" | base64 -d > /tmp/id_rsa
    chmod 600 /tmp/id_rsa
}

ssh_client_config () {
    print_message 'stdout' 'configure client ssh config'
    cat <<EOF > /tmp/ssh_config
Host netmon kube0* watcher* dns wrkstn
    User austin

Host tvault
    User sshd

Host labs.elysianskies.com
    User austin
    Port 6945
EOF
    chmod 600 /tmp/ssh_config
}

