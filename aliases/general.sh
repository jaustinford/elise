# color
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color '
alias tree='tree -C'

# general
alias change_vpn_server="${ELISE_ROOT_DIR}/scripts/change_vpn_server.sh change"
alias countdown="${ELISE_ROOT_DIR}/scripts/countdown.sh"
alias eslabs_deploy="${ELISE_ROOT_DIR}/scripts/eslabs.sh deploy"
alias eslabs_destroy="${ELISE_ROOT_DIR}/scripts/eslabs.sh destroy"
alias nuke="${ELISE_ROOT_DIR}/scripts/countdown.sh \"${ELISE_ROOT_DIR}/scripts/eslabs.sh destroy; ${ELISE_ROOT_DIR}/scripts/eslabs.sh deploy\""
alias scp='scp -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no -o LogLevel=ERROR'
alias ssh='ssh -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no -o LogLevel=ERROR'
alias ssl_eslabs_display="ssl_reader ${LAB_FQDN} 443"
alias ssl_eslabs_generate="kube_exec eslabs \$(pod_from_deployment eslabs acme wait) acme 'rm -rf /etc/letsencrypt/*; /tmp/certbot.sh'"
alias tree_project="tree -a -I '.git|*_history|.viminfo|.config|.vim|.kube|.ssh|dropoff|.cache|.lesshst|.ansible' ${ELISE_ROOT_DIR}"
