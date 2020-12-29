# color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias tree='tree -C'
alias ls='ls --color '

# kubernetes - general
alias k_manifest_apply="${ELISE_ROOT_DIR}/scripts/run_manifest.sh apply"
alias k_manifest_delete="${ELISE_ROOT_DIR}/scripts/run_manifest.sh delete"
alias k_manifest_diff="${ELISE_ROOT_DIR}/scripts/run_manifest.sh diff"
alias k_manifest_edit="${ELISE_ROOT_DIR}/scripts/run_manifest.sh edit"
alias k_manifest_list="ls -m1 ${KUBE_MANIFESTS_DIR} | cut -d'.' -f1"

alias k_start="${ELISE_ROOT_DIR}/scripts/kube_automator.sh start"
alias k_stop="${ELISE_ROOT_DIR}/scripts/kube_automator.sh stop"
alias k_restart="${ELISE_ROOT_DIR}/scripts/kube_automator.sh restart"
alias k_logs="${ELISE_ROOT_DIR}/scripts/kube_automator.sh logs"
alias k_tail="${ELISE_ROOT_DIR}/scripts/kube_automator.sh tail"
alias k_exec="${ELISE_ROOT_DIR}/scripts/kube_automator.sh exec"
alias k_shell="${ELISE_ROOT_DIR}/scripts/kube_automator.sh shell"
alias k_edit="${ELISE_ROOT_DIR}/scripts/kube_automator.sh edit"
alias k_describe="${ELISE_ROOT_DIR}/scripts/kube_automator.sh describe"
alias k_nodes="${ELISE_ROOT_DIR}/scripts/kube_automator.sh nodes"
alias k_events="${ELISE_ROOT_DIR}/scripts/kube_automator.sh events"
alias k_display="${ELISE_ROOT_DIR}/scripts/kube_automator.sh display"
alias k_crash="${ELISE_ROOT_DIR}/scripts/kube_automator.sh crash"
alias k_watch="watch -n 5 -t -c ${ELISE_ROOT_DIR}/scripts/kube_automator.sh display"

# kubernetes - kube-system namespace
alias k_system_tail="${ELISE_ROOT_DIR}/scripts/kube_automator.sh tail kube-system"
alias k_system_events="${ELISE_ROOT_DIR}/scripts/kube_automator.sh events kube-system"
alias k_system_display="${ELISE_ROOT_DIR}/scripts/kube_automator.sh display kube-system"
alias k_system_watch="watch -n 5 -t -c ${ELISE_ROOT_DIR}/scripts/kube_automator.sh display kube-system"

# kubernetes - eslabs namespace
alias k_eslabs_start="${ELISE_ROOT_DIR}/scripts/kube_automator.sh start eslabs"
alias k_eslabs_stop="${ELISE_ROOT_DIR}/scripts/kube_automator.sh stop eslabs"
alias k_eslabs_restart="${ELISE_ROOT_DIR}/scripts/kube_automator.sh restart eslabs"
alias k_eslabs_logs="${ELISE_ROOT_DIR}/scripts/kube_automator.sh logs eslabs"
alias k_eslabs_tail="${ELISE_ROOT_DIR}/scripts/kube_automator.sh tail eslabs"
alias k_eslabs_exec="${ELISE_ROOT_DIR}/scripts/kube_automator.sh exec eslabs"
alias k_eslabs_shell="${ELISE_ROOT_DIR}/scripts/kube_automator.sh shell eslabs"
alias k_eslabs_edit="${ELISE_ROOT_DIR}/scripts/kube_automator.sh edit eslabs"
alias k_eslabs_describe="${ELISE_ROOT_DIR}/scripts/kube_automator.sh describe eslabs"
alias k_eslabs_events="${ELISE_ROOT_DIR}/scripts/kube_automator.sh events eslabs"
alias k_eslabs_display="${ELISE_ROOT_DIR}/scripts/kube_automator.sh display eslabs"
alias k_eslabs_crash="${ELISE_ROOT_DIR}/scripts/kube_automator.sh crash eslabs"
alias k_eslabs_crash_kharon_squid="${ELISE_ROOT_DIR}/scripts/kube_automator.sh crash eslabs kharon squid"
alias k_eslabs_crash_kharon_deluge="${ELISE_ROOT_DIR}/scripts/kube_automator.sh crash eslabs kharon deluge"
alias k_eslabs_watch="watch -n 5 -t -c ${ELISE_ROOT_DIR}/scripts/kube_automator.sh display eslabs"

# git
alias g_add="${ELISE_ROOT_DIR}/scripts/git_automator.sh add"
alias g_commit="${ELISE_ROOT_DIR}/scripts/git_automator.sh commit"
alias g_push="${ELISE_ROOT_DIR}/scripts/git_automator.sh push"
alias g_spot="${ELISE_ROOT_DIR}/scripts/git_automator.sh all"
alias g_status="git status"
alias g_reset="git reset --hard"
alias g_log="git log --patch"
alias g_diff="git diff"

# misc
alias _aliases="vim ${ELISE_ROOT_DIR}/.bash_aliases"
alias _source="source ${ELISE_ROOT_DIR}/.bash_profile"
alias _scripts="cd ${ELISE_ROOT_DIR}/scripts"
alias _src="cd ${ELISE_ROOT_DIR}/src"
alias _manifests="cd ${KUBE_MANIFESTS_DIR}"
alias _home="cd ~"
alias _vars="${EDITOR} ${ELISE_ROOT_DIR}/src/elise.env"
alias _profile="${EDITOR} ${ELISE_ROOT_DIR}/.bash_profile"
alias _plexspy="${ELISE_ROOT_DIR}/scripts/kube_automator.sh tail eslabs tautulli | egrep 'Session\ [0-9]{1,}\ started'"
alias _sed_edit="${ELISE_ROOT_DIR}/scripts/sed.sh replace"
alias youdown="${ELISE_ROOT_DIR}/scripts/youdown.sh"
alias ssh='ssh -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no'
alias scp='scp -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no'
