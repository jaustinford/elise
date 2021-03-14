# color
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color '
alias tree='tree -C'

# kubernetes - general
alias k_crash="${ELISE_ROOT_DIR}/scripts/kube_automator.sh crash"
alias k_describe="${ELISE_ROOT_DIR}/scripts/kube_automator.sh describe"
alias k_display="${ELISE_ROOT_DIR}/scripts/kube_automator.sh display"
alias k_edit="${ELISE_ROOT_DIR}/scripts/kube_automator.sh edit"
alias k_exec="${ELISE_ROOT_DIR}/scripts/kube_automator.sh exec"
alias k_get="${ELISE_ROOT_DIR}/scripts/kube_automator.sh get"
alias k_logs="${ELISE_ROOT_DIR}/scripts/kube_automator.sh logs"
alias k_nodes="${ELISE_ROOT_DIR}/scripts/kube_automator.sh nodes"
alias k_restart="${ELISE_ROOT_DIR}/scripts/kube_automator.sh restart"
alias k_shell="${ELISE_ROOT_DIR}/scripts/kube_automator.sh shell"
alias k_start="${ELISE_ROOT_DIR}/scripts/kube_automator.sh start"
alias k_stop="${ELISE_ROOT_DIR}/scripts/kube_automator.sh stop"
alias k_tail="${ELISE_ROOT_DIR}/scripts/kube_automator.sh tail"
alias k_watch="watch -n 5 -t -c ${ELISE_ROOT_DIR}/scripts/kube_automator.sh display"

# kubernetes - manifests
alias k_manifest_apply="${ELISE_ROOT_DIR}/scripts/run_manifest.sh apply"
alias k_manifest_delete="${ELISE_ROOT_DIR}/scripts/run_manifest.sh delete"
alias k_manifest_diff="${ELISE_ROOT_DIR}/scripts/run_manifest.sh diff"
alias k_manifest_edit="${ELISE_ROOT_DIR}/scripts/run_manifest.sh edit"
alias k_manifest_list="ls -m1 ${ELISE_ROOT_DIR}/manifests | cut -d'.' -f1"

# kubernetes - kube-system namespace
alias k_system_describe="${ELISE_ROOT_DIR}/scripts/kube_automator.sh describe kube-system"
alias k_system_display="${ELISE_ROOT_DIR}/scripts/kube_automator.sh display kube-system"
alias k_system_events="${ELISE_ROOT_DIR}/scripts/kube_automator.sh get kube-system events"
alias k_system_get="${ELISE_ROOT_DIR}/scripts/kube_automator.sh get kube-system"
alias k_system_tail="${ELISE_ROOT_DIR}/scripts/kube_automator.sh tail kube-system"
alias k_system_watch="watch -n 5 -t -c ${ELISE_ROOT_DIR}/scripts/kube_automator.sh display kube-system"

# kubernetes - ingress-nginx namespace
alias k_ingress_describe="${ELISE_ROOT_DIR}/scripts/kube_automator.sh describe ingress-nginx"
alias k_ingress_display="${ELISE_ROOT_DIR}/scripts/kube_automator.sh display ingress-nginx"
alias k_ingress_events="${ELISE_ROOT_DIR}/scripts/kube_automator.sh get ingress-nginx events"
alias k_ingress_get="${ELISE_ROOT_DIR}/scripts/kube_automator.sh get ingress-nginx"
alias k_ingress_tail="${ELISE_ROOT_DIR}/scripts/kube_automator.sh tail ingress-nginx"
alias k_ingress_watch="watch -n 5 -t -c ${ELISE_ROOT_DIR}/scripts/kube_automator.sh display ingress-nginx"

# kubernetes - eslabs namespace
alias k_eslabs_crash="${ELISE_ROOT_DIR}/scripts/kube_automator.sh crash eslabs"
alias k_eslabs_crash_kharon_deluge="${ELISE_ROOT_DIR}/scripts/kube_automator.sh crash eslabs kharon deluge"
alias k_eslabs_crash_kharon_squid="${ELISE_ROOT_DIR}/scripts/kube_automator.sh crash eslabs kharon squid"
alias k_eslabs_describe="${ELISE_ROOT_DIR}/scripts/kube_automator.sh describe eslabs"
alias k_eslabs_display="${ELISE_ROOT_DIR}/scripts/kube_automator.sh display eslabs"
alias k_eslabs_edit="${ELISE_ROOT_DIR}/scripts/kube_automator.sh edit eslabs"
alias k_eslabs_events="${ELISE_ROOT_DIR}/scripts/kube_automator.sh get eslabs events"
alias k_eslabs_exec="${ELISE_ROOT_DIR}/scripts/kube_automator.sh exec eslabs"
alias k_eslabs_get="${ELISE_ROOT_DIR}/scripts/kube_automator.sh get eslabs"
alias k_eslabs_logs="${ELISE_ROOT_DIR}/scripts/kube_automator.sh logs eslabs"
alias k_eslabs_restart="${ELISE_ROOT_DIR}/scripts/kube_automator.sh restart eslabs"
alias k_eslabs_shell="${ELISE_ROOT_DIR}/scripts/kube_automator.sh shell eslabs"
alias k_eslabs_start="${ELISE_ROOT_DIR}/scripts/kube_automator.sh start eslabs"
alias k_eslabs_stop="${ELISE_ROOT_DIR}/scripts/kube_automator.sh stop eslabs"
alias k_eslabs_tail="${ELISE_ROOT_DIR}/scripts/kube_automator.sh tail eslabs"
alias k_eslabs_watch="watch -n 5 -t -c ${ELISE_ROOT_DIR}/scripts/kube_automator.sh display eslabs"

# git
alias g_add="${ELISE_ROOT_DIR}/scripts/git_automator.sh add"
alias g_commit="${ELISE_ROOT_DIR}/scripts/git_automator.sh commit"
alias g_diff="git diff"
alias g_log="git log --patch"
alias g_push="${ELISE_ROOT_DIR}/scripts/git_automator.sh push"
alias g_reset="git reset --hard"
alias g_status="git status"
alias g_spot="${ELISE_ROOT_DIR}/scripts/git_automator.sh all"

# ansible - playbooks
alias a_crons="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/crons.yml"
alias a_docker="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/docker.yml"
alias a_general="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/general.yml"
alias a_haproxy_restart="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/haproxy.yml --extra-vars \"container_state=started recreate_container=yes message=restarting\""
alias a_haproxy_start="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/haproxy.yml --extra-vars \"container_state=started recreate_container=no message=starting\""
alias a_haproxy_stop="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/haproxy.yml --extra-vars \"container_state=stopped recreate_container=no message=stopping\""
alias a_kubernetes="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/kubernetes.yml"
alias a_lab_backup_copy="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/lab_backup.yml --extra-vars option=copy"
alias a_lab_backup_execute="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/lab_backup.yml --extra-vars option=execute"
alias a_lab_backup_remove="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/lab_backup.yml --extra-vars option=remove"
alias a_nrpe="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/nrpe.yml"
alias a_ntopng="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/ntopng.yml"
alias a_pihole="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/pihole.yml"
alias a_sudoers="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/sudoers.yml --ask-become-pass"
alias a_watchers_install="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/watchers.yml --extra-vars \"option=install\""
alias a_watchers_start="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/watchers.yml --extra-vars \"option=start\""
alias a_watchers_stop="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks/watchers.yml --extra-vars \"option=stop\""

# bash
alias _aliases="${EDITOR} ${ELISE_ROOT_DIR}/.bash_aliases"
alias _lines="permissions_and_dos_line_endings ${ELISE_ROOT_DIR}"
alias _profile="${EDITOR} ${ELISE_ROOT_DIR}/.bash_profile"
alias _source="clear; source ${ELISE_ROOT_DIR}/.bash_profile"
alias _vars="${EDITOR} ${ELISE_ROOT_DIR}/src/elise.sh"

# misc
alias change_vpn_server="${ELISE_ROOT_DIR}/scripts/change_vpn_server.sh change"
alias countdown="${ELISE_ROOT_DIR}/scripts/countdown.sh"
alias eslabs_deploy="${ELISE_ROOT_DIR}/scripts/eslabs.sh deploy"
alias eslabs_destroy="${ELISE_ROOT_DIR}/scripts/eslabs.sh destroy"
alias nuke="${ELISE_ROOT_DIR}/scripts/countdown.sh \"${ELISE_ROOT_DIR}/scripts/eslabs.sh destroy; ${ELISE_ROOT_DIR}/scripts/eslabs.sh deploy\""
alias scp='scp -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no'
alias ssh='ssh -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no'
alias ssl_display="ssl_reader ${LAB_FQDN} 443"
alias ssl_generate="${ELISE_ROOT_DIR}/scripts/ssl.sh"
alias youdown="${ELISE_ROOT_DIR}/scripts/youdown.sh"
