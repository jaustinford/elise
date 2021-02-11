 #!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

pod_from_deployment 'eslabs' 'acme' 'wait'
kube_exec 'eslabs' "$pod" 'acme' 'rm -rf /etc/letsencrypt/*; /tmp/certbot.sh'
