alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color '
alias scp='scp -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no -o LogLevel=ERROR'
alias ssh='ssh -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no -o LogLevel=ERROR'
alias tree='tree -C'
alias tree_project="tree -a -I '.git|*_history|.viminfo|.config|.vim|.kube|.ssh|dropoff|.cache|.lesshst|.ansible' ${ELISE_ROOT_DIR}"
