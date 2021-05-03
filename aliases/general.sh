LOG_DIR='/mnt/tvault/es-labs/logs'

# color
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color '
alias tree='tree -C'

# general
alias eslabs_deploy="${ELISE_ROOT_DIR}/scripts/eslabs.sh deploy"
alias eslabs_destroy="${ELISE_ROOT_DIR}/scripts/eslabs.sh destroy"
alias hyperion_off="${KUBE_AUTOMATOR} stop eslabs hyperion; ${ANSIBLE_PLAYBOOK}/watchers.yml --extra-vars \"option=stop\""
alias hyperion_on="${KUBE_AUTOMATOR} start eslabs hyperion; ${ANSIBLE_PLAYBOOK}/watchers.yml --extra-vars \"option=start\""
alias logs_haproxy='ssh kube00 sudo docker logs -f haproxy'
alias logs_soteria="ssh kube02 tail -f ${LOG_DIR}/soteria-kube02.labs.elysianskies.com.log"
alias nuke="countdown_to_cmd \"${ELISE_ROOT_DIR}/scripts/eslabs.sh destroy; ${ELISE_ROOT_DIR}/scripts/eslabs.sh deploy\""
alias pihole_update='ssh dns sudo pihole -up'
alias scp='scp -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no -o LogLevel=ERROR'
alias ssh='ssh -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no -o LogLevel=ERROR'
alias tree_project="tree -a -I '.git|*_history|.viminfo|.config|.vim|.kube|.ssh|dropoff|.cache|.lesshst|.ansible' ${ELISE_ROOT_DIR}"

# ssl
alias ssl_eslabs_display="ssl_reader ${LAB_FQDN} 443"
alias ssl_eslabs_generate="kube_exec eslabs \$(pod_from_deployment eslabs hermes wait) hermes '/tmp/certbot.sh generate'"
alias ssl_eslabs_renew="kube_exec eslabs \$(pod_from_deployment eslabs hermes wait) hermes '/tmp/certbot.sh renew'"
alias ssl_eslabs_stage="kube_exec eslabs \$(pod_from_deployment eslabs hermes wait) hermes '/tmp/certbot.sh'"
