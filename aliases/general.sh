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
alias eslabs_nuke="countdown_to_cmd \"${ELISE_ROOT_DIR}/scripts/eslabs.sh stop; ${ELISE_ROOT_DIR}/scripts/eslabs.sh destroy yes; ${ELISE_ROOT_DIR}/scripts/eslabs.sh deploy\""
alias eslabs_shutdown="${ELISE_ROOT_DIR}/scripts/eslabs.sh shutdown"
alias eslabs_stop="${ELISE_ROOT_DIR}/scripts/eslabs.sh stop"
alias hyperion_arm="zoneminder_api_change_function_all_monitors Modect 1"
alias hyperion_disarm="zoneminder_api_change_function_all_monitors Monitor 1"
alias hyperion_off="${ANSIBLE_PLAYBOOK}/watchers.yml --extra-vars \"option=stop\"; zoneminder_api_change_function_all_monitors None 0"
alias hyperion_on="${ANSIBLE_PLAYBOOK}/watchers.yml --extra-vars \"option=start\"; zoneminder_api_change_function_all_monitors Monitor 1"
alias logs_full_haproxy='ssh kube00 sudo docker logs haproxy'
alias logs_full_soteria="ssh kube02 cat ${LOG_DIR}/soteria-kube02.labs.elysianskies.com.log"
alias logs_tail_haproxy='ssh kube00 sudo docker logs -f haproxy'
alias logs_tail_soteria="ssh kube02 tail -f ${LOG_DIR}/soteria-kube02.labs.elysianskies.com.log"
alias pihole_update='ssh dns sudo pihole -up'
alias scp='scp -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no -o LogLevel=ERROR'
alias ssh='ssh -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no -o LogLevel=ERROR'
alias tree_project="tree -a -I '.git|*_history|.viminfo|.config|.vim|.kube|.ssh|dropoff|.cache|.lesshst|.ansible' ${ELISE_ROOT_DIR}"

# ssl
alias ssl_eslabs_display="ssl_reader ${LAB_FQDN} 443"
alias ssl_eslabs_generate="kube_exec eslabs \$(pod_from_deployment eslabs hermes wait) hermes '/tmp/certbot.sh generate'"
alias ssl_eslabs_renew="kube_exec eslabs \$(pod_from_deployment eslabs hermes wait) hermes '/tmp/certbot.sh renew'"
alias ssl_eslabs_stage="kube_exec eslabs \$(pod_from_deployment eslabs hermes wait) hermes '/tmp/certbot.sh'"
