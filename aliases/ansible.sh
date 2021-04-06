ANSIBLE_PLAYBOOK="ansible-playbook ${ELISE_ROOT_DIR}/ansible/playbooks"

# ansible-playbooks
alias a_crons_deploy="${ANSIBLE_PLAYBOOK}/crons.yml"
alias a_crons_edit="${EDITOR} ${ELISE_ROOT_DIR}/ansible/playbooks/crons.yml"
alias a_docker="${ANSIBLE_PLAYBOOK}/docker.yml"
alias a_general="${ANSIBLE_PLAYBOOK}/general.yml"
alias a_haproxy_restart="${ANSIBLE_PLAYBOOK}/haproxy.yml --extra-vars \"container_state=started recreate_container=yes message=restarting\""
alias a_haproxy_start="${ANSIBLE_PLAYBOOK}/haproxy.yml --extra-vars \"container_state=started recreate_container=no message=starting\""
alias a_haproxy_stop="${ANSIBLE_PLAYBOOK}/haproxy.yml --extra-vars \"container_state=stopped recreate_container=no message=stopping\""
alias a_kubernetes="${ANSIBLE_PLAYBOOK}/kubernetes.yml"
alias a_nrpe="${ANSIBLE_PLAYBOOK}/nrpe.yml"
alias a_ntopng="${ANSIBLE_PLAYBOOK}/ntopng.yml"
alias a_pihole="${ANSIBLE_PLAYBOOK}/pihole.yml"
alias a_soteria_deploy="vars_ensure decrypted; ${ANSIBLE_PLAYBOOK}/soteria.yml --extra-vars option=deploy"
alias a_soteria_execute="${ANSIBLE_PLAYBOOK}/soteria.yml --extra-vars option=execute"
alias a_soteria_remove="${ANSIBLE_PLAYBOOK}/soteria.yml --extra-vars option=remove"
alias a_sudoers="${ANSIBLE_PLAYBOOK}/sudoers.yml --ask-become-pass"
alias a_watchers_install="${ANSIBLE_PLAYBOOK}/watchers.yml --extra-vars option=install"
alias a_watchers_start="${ANSIBLE_PLAYBOOK}/watchers.yml --extra-vars option=start"
alias a_watchers_stop="${ANSIBLE_PLAYBOOK}/watchers.yml --extra-vars option=stop"

# ansible-vault
alias a_decrypt="ansible-vault decrypt --vault-password-file=~/.vault.txt"
alias a_edit="ansible-vault edit --vault-password-file=~/.vault.txt"
alias a_encrypt="ansible-vault encrypt --vault-password-file=~/.vault.txt"

# commands
alias a_ping="ansible all -m ping"
