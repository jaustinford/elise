# color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias tree='tree -C'
alias ls='ls --color '

# watchers
# alias watcher_start="${SHELL_ROOT_DIR}/scripts/watcher/rtsp_server.py start"
# alias watcher_stop="${SHELL_ROOT_DIR}/scripts/watcher/rtsp_server.py stop"

# kubernetes
alias k_manifest_apply="${KUBE_MANIFESTS_DIR}/run_manifest.sh apply"
alias k_manifest_delete="${KUBE_MANIFESTS_DIR}/run_manifest.sh delete"
alias k_manifest_diff="${KUBE_MANIFESTS_DIR}/run_manifest.sh diff"
alias k_manifest_edit="${KUBE_MANIFESTS_DIR}/run_manifest.sh edit"

alias k_start="${SHELL_ROOT_DIR}/scripts/kube_automator.sh start"
alias k_stop="${SHELL_ROOT_DIR}/scripts/kube_automator.sh stop"
alias k_logs="${SHELL_ROOT_DIR}/scripts/kube_automator.sh logs"
alias k_tail="${SHELL_ROOT_DIR}/scripts/kube_automator.sh tail"
alias k_exec="${SHELL_ROOT_DIR}/scripts/kube_automator.sh exec"
alias k_shell="${SHELL_ROOT_DIR}/scripts/kube_automator.sh shell"
alias k_edit="${SHELL_ROOT_DIR}/scripts/kube_automator.sh edit"
alias k_describe="${SHELL_ROOT_DIR}/scripts/kube_automator.sh describe"
alias k_nodes="${SHELL_ROOT_DIR}/scripts/kube_automator.sh nodes"
alias k_events="${SHELL_ROOT_DIR}/scripts/kube_automator.sh events"
alias k_display="${SHELL_ROOT_DIR}/scripts/kube_automator.sh display"
alias k_watch="watch -n 5 -t -c ${SHELL_ROOT_DIR}/scripts/kube_automator.sh display"

alias k_eslabs_start="${SHELL_ROOT_DIR}/scripts/kube_automator.sh start eslabs"
alias k_eslabs_stop="${SHELL_ROOT_DIR}/scripts/kube_automator.sh stop eslabs"
alias k_eslabs_logs="${SHELL_ROOT_DIR}/scripts/kube_automator.sh logs eslabs"
alias k_eslabs_tail="${SHELL_ROOT_DIR}/scripts/kube_automator.sh tail eslabs"
alias k_eslabs_exec="${SHELL_ROOT_DIR}/scripts/kube_automator.sh exec eslabs"
alias k_eslabs_shell="${SHELL_ROOT_DIR}/scripts/kube_automator.sh shell eslabs"
alias k_eslabs_edit="${SHELL_ROOT_DIR}/scripts/kube_automator.sh edit eslabs"
alias k_eslabs_describe="${SHELL_ROOT_DIR}/scripts/kube_automator.sh describe eslabs"
alias k_eslabs_events="${SHELL_ROOT_DIR}/scripts/kube_automator.sh events eslabs"
alias k_eslabs_display="${SHELL_ROOT_DIR}/scripts/kube_automator.sh display eslabs"
alias k_eslabs_watch="watch -n 5 -t -c ${SHELL_ROOT_DIR}/scripts/kube_automator.sh display eslabs"

alias k_system_tail="${SHELL_ROOT_DIR}/scripts/kube_automator.sh tail kube-system"
alias k_system_events="${SHELL_ROOT_DIR}/scripts/kube_automator.sh events kube-system"
alias k_system_display="${SHELL_ROOT_DIR}/scripts/kube_automator.sh display kube-system"
alias k_system_watch="watch -n 5 -t -c ${SHELL_ROOT_DIR}/scripts/kube_automator.sh display kube-system"

# iscsi
# alias v_mount="${SHELL_ROOT_DIR}/scripts/iscsi_automator.sh mount"
# alias v_dismount="${SHELL_ROOT_DIR}/scripts/iscsi_automator.sh dismount"
# alias v_backup="${SHELL_ROOT_DIR}/scripts/iscsi_automator.sh backup"
# alias v_backup_lab="${SHELL_ROOT_DIR}/scripts/lab_backup.sh"

# git
alias g_add="${SHELL_ROOT_DIR}/scripts/git_automator.sh add"
alias g_commit="${SHELL_ROOT_DIR}/scripts/git_automator.sh commit"
alias g_push="${SHELL_ROOT_DIR}/scripts/git_automator.sh push"
alias g_spot="${SHELL_ROOT_DIR}/scripts/git_automator.sh all"
alias g_status="git status"
alias g_reset="git reset --hard"
alias g_log="git log --patch"
alias g_diff="git diff"

# misc
alias _aliases="vim ${SHELL_ROOT_DIR}/.bash_aliases"
alias _scripts="cd ${SHELL_ROOT_DIR}/scripts"
alias _src="cd ${SHELL_ROOT_DIR}/src"
alias _manifests="cd ${KUBE_MANIFESTS_DIR}"
alias _source="source ${SHELL_ROOT_DIR}/.bash_profile"
alias _home="cd ~"
alias _vars="${EDITOR} ${SHELL_ROOT_DIR}/src/eslabs.env"
alias _profile="${EDITOR} ${SHELL_ROOT_DIR}/.bash_profile"
alias _expressvpn="${SHELL_ROOT_DIR}/scripts/kube_automator.sh exec eslabs kharon 'expressvpn status' expressvpn"
alias _plexspy="${SHELL_ROOT_DIR}/scripts/kube_automator.sh tail eslabs tautulli | egrep 'Session\ [0-9]{1,}\ started'"
# alias _sed_edit="${SHELL_ROOT_DIR}/scripts/eslabs_shell.sh edit"
# alias torrent_cli='docker exec -it plex-pipeline torrent_cli.py'
# alias rpi_temp="${SHELL_ROOT_DIR}/scripts/rpi_temp.sh"
alias youdown="${SHELL_ROOT_DIR}/scripts/youdown.sh"
alias ssh='ssh -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no'
