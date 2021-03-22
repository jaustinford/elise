KUBE_AUTOMATOR="${ELISE_ROOT_DIR}/scripts/kube_automator.sh"
GIT_AUTOMATOR="${ELISE_ROOT_DIR}/scripts/git_automator.sh"
RUN_MANIFEST="${ELISE_ROOT_DIR}/scripts/run_manifest.sh"
ANSIBLE_PLAYBOOK="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks"

# color
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color '
alias tree='tree -C'

# kubernetes - general
alias k_crash="${KUBE_AUTOMATOR} crash"
alias k_describe="${KUBE_AUTOMATOR} describe"
alias k_display="${KUBE_AUTOMATOR} display"
alias k_edit="${KUBE_AUTOMATOR} edit"
alias k_exec="${KUBE_AUTOMATOR} exec"
alias k_get="${KUBE_AUTOMATOR} get"
alias k_logs="${KUBE_AUTOMATOR} logs"
alias k_nodes="${KUBE_AUTOMATOR} nodes"
alias k_restart="${KUBE_AUTOMATOR} restart"
alias k_shell="${KUBE_AUTOMATOR} shell"
alias k_start="${KUBE_AUTOMATOR} start"
alias k_stop="${KUBE_AUTOMATOR} stop"
alias k_tail="${KUBE_AUTOMATOR} tail"
alias k_watch="watch -n 5 -t -c ${KUBE_AUTOMATOR} display"

# kubernetes - manifests
alias k_manifest_apply="${RUN_MANIFEST} apply"
alias k_manifest_delete="${RUN_MANIFEST} delete"
alias k_manifest_diff="${RUN_MANIFEST} diff"
alias k_manifest_edit="${RUN_MANIFEST} edit"
alias k_manifest_list="ls -m1 ${ELISE_ROOT_DIR}/manifests | cut -d'.' -f1"

# kubernetes - kube-system namespace
alias k_system_describe="${KUBE_AUTOMATOR} describe kube-system"
alias k_system_display="${KUBE_AUTOMATOR} display kube-system"
alias k_system_events="${KUBE_AUTOMATOR} get kube-system events"
alias k_system_get="${KUBE_AUTOMATOR} get kube-system"
alias k_system_tail="${KUBE_AUTOMATOR} tail kube-system"
alias k_system_watch="watch -n 5 -t -c ${KUBE_AUTOMATOR} display kube-system"

# kubernetes - ingress-nginx namespace
alias k_ingress_describe="${KUBE_AUTOMATOR} describe ingress-nginx"
alias k_ingress_display="${KUBE_AUTOMATOR} display ingress-nginx"
alias k_ingress_events="${KUBE_AUTOMATOR} get ingress-nginx events"
alias k_ingress_get="${KUBE_AUTOMATOR} get ingress-nginx"
alias k_ingress_tail="${KUBE_AUTOMATOR} tail ingress-nginx"
alias k_ingress_watch="watch -n 5 -t -c ${KUBE_AUTOMATOR} display ingress-nginx"

# kubernetes - eslabs namespace
alias k_eslabs_crash="${KUBE_AUTOMATOR} crash eslabs"
alias k_eslabs_crash_kharon_deluge="${KUBE_AUTOMATOR} crash eslabs kharon deluge"
alias k_eslabs_crash_kharon_squid="${KUBE_AUTOMATOR} crash eslabs kharon squid"
alias k_eslabs_describe="${KUBE_AUTOMATOR} describe eslabs"
alias k_eslabs_display="${KUBE_AUTOMATOR} display eslabs"
alias k_eslabs_edit="${KUBE_AUTOMATOR} edit eslabs"
alias k_eslabs_events="${KUBE_AUTOMATOR} get eslabs events"
alias k_eslabs_exec="${KUBE_AUTOMATOR} exec eslabs"
alias k_eslabs_get="${KUBE_AUTOMATOR} get eslabs"
alias k_eslabs_logs="${KUBE_AUTOMATOR} logs eslabs"
alias k_eslabs_restart="${KUBE_AUTOMATOR} restart eslabs"
alias k_eslabs_shell="${KUBE_AUTOMATOR} shell eslabs"
alias k_eslabs_start="${KUBE_AUTOMATOR} start eslabs"
alias k_eslabs_stop="${KUBE_AUTOMATOR} stop eslabs"
alias k_eslabs_tail="${KUBE_AUTOMATOR} tail eslabs"
alias k_eslabs_watch="watch -n 5 -t -c ${KUBE_AUTOMATOR} display eslabs"

# git
alias g_add="${GIT_AUTOMATOR} add"
alias g_commit="${GIT_AUTOMATOR} commit"
alias g_diff="git diff -- ':(exclude)${ELISE_ROOT_DIR}/src/elise.sh'"
alias g_log="git log --patch -- ':(exclude)${ELISE_ROOT_DIR}/src/elise.sh'"
alias g_push="${GIT_AUTOMATOR} push"
alias g_reset="git reset --hard"
alias g_status="git status"
alias g_spot="${GIT_AUTOMATOR} all"

# ansible - playbooks
alias a_crons_deploy="${ANSIBLE_PLAYBOOK}/crons.yml"
alias a_crons_edit="${EDITOR} ${ELISE_ROOT_DIR}/ansible/playbooks/crons.yml"
alias a_docker="${ANSIBLE_PLAYBOOK}/docker.yml"
alias a_general="${ANSIBLE_PLAYBOOK}/general.yml"
alias a_haproxy_restart="${ANSIBLE_PLAYBOOK}/haproxy.yml --extra-vars \"container_state=started recreate_container=yes message=restarting\""
alias a_haproxy_start="${ANSIBLE_PLAYBOOK}/haproxy.yml --extra-vars \"container_state=started recreate_container=no message=starting\""
alias a_haproxy_stop="${ANSIBLE_PLAYBOOK}/haproxy.yml --extra-vars \"container_state=stopped recreate_container=no message=stopping\""
alias a_kubernetes="${ANSIBLE_PLAYBOOK}/kubernetes.yml"
alias a_lab_backup_copy="${ANSIBLE_PLAYBOOK}/lab_backup.yml --extra-vars option=copy"
alias a_lab_backup_execute="${ANSIBLE_PLAYBOOK}/lab_backup.yml --extra-vars option=execute"
alias a_lab_backup_remove="${ANSIBLE_PLAYBOOK}/lab_backup.yml --extra-vars option=remove"
alias a_nrpe="${ANSIBLE_PLAYBOOK}/nrpe.yml"
alias a_ntopng="${ANSIBLE_PLAYBOOK}/ntopng.yml"
alias a_pihole="${ANSIBLE_PLAYBOOK}/pihole.yml"
alias a_ping="ansible all -m ping"
alias a_sudoers="${ANSIBLE_PLAYBOOK}/sudoers.yml --ask-become-pass"
alias a_vault_decrypt="ansible-vault decrypt --vault-password-file=~/.vault.txt"
alias a_vault_edit="ansible-vault edit --vault-password-file=~/.vault.txt"
alias a_vault_encrypt="ansible-vault encrypt --vault-password-file=~/.vault.txt"
alias a_watchers_install="${ANSIBLE_PLAYBOOK}/watchers.yml --extra-vars \"option=install\""
alias a_watchers_start="${ANSIBLE_PLAYBOOK}/watchers.yml --extra-vars \"option=start\""
alias a_watchers_stop="${ANSIBLE_PLAYBOOK}/watchers.yml --extra-vars \"option=stop\""

# bash
alias _aliases="${EDITOR} ${ELISE_ROOT_DIR}/.bash_aliases"
alias _lines="permissions_and_dos_line_endings ${ELISE_ROOT_DIR}"
alias _profile="${EDITOR} ${ELISE_ROOT_DIR}/.bash_profile"
alias _source="source ${ELISE_ROOT_DIR}/.bash_profile"
alias _vars_decrypt="ansible-vault decrypt --vault-password-file=~/.vault.txt ${ELISE_ROOT_DIR}/src/elise.sh"
alias _vars_edit="${EDITOR} ${ELISE_ROOT_DIR}/src/elise.sh"
alias _vars_encrypt="ansible-vault encrypt --vault-password-file=~/.vault.txt ${ELISE_ROOT_DIR}/src/elise.sh"

# misc
alias change_vpn_server="${ELISE_ROOT_DIR}/scripts/change_vpn_server.sh change"
alias countdown="${ELISE_ROOT_DIR}/scripts/countdown.sh"
alias eslabs_deploy="${ELISE_ROOT_DIR}/scripts/eslabs.sh deploy"
alias eslabs_destroy="${ELISE_ROOT_DIR}/scripts/eslabs.sh destroy"
alias gen_kube_config="kube_config ${ELISE_ROOT_DIR} ${LAB_FQDN}"
alias nuke="${ELISE_ROOT_DIR}/scripts/countdown.sh \"${ELISE_ROOT_DIR}/scripts/eslabs.sh destroy; ${ELISE_ROOT_DIR}/scripts/eslabs.sh deploy\""
alias scp='scp -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no -o LogLevel=ERROR'
alias ssh='ssh -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no -o LogLevel=ERROR'
alias ssl_display="ssl_reader ${LAB_FQDN} 443"
alias ssl_generate="${ELISE_ROOT_DIR}/scripts/ssl.sh"
alias youdown="${ELISE_ROOT_DIR}/scripts/youdown.sh"
