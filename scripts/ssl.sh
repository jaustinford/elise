 #!/usr/bin/env bash

# set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

MODE="$1"

pod_from_deployment 'eslabs' 'acme' 'wait'

if [ "${MODE}" == 'generate' ]; then
    kube_exec 'eslabs' "$pod" 'acme' 'rm -rf /etc/letsencrypt/*; /tmp/certbot.sh generate'

elif [ "${MODE}" == 'display' ]; then
    ssl_info "${LAB_FQDN}" '443'

fi
