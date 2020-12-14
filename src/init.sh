ssh_key() {
    print_message 'stdout' 'adding user ssh key'
    mkdir -p "${HOME}/.ssh/keys"
    rm -f "${HOME}/.ssh/id_rsa"
    echo "${AUSTIN_SSH_KEY}" | base64 -d > "${HOME}/.ssh/id_rsa"
    chmod 600 "${HOME}/.ssh/id_rsa"
}
