#!/usr/bin/env bash

set -e

. ${ELISE_ROOT_DIR}/src/elise.sh
. ${ELISE_ROOT_DIR}/src/general.sh
. ${ELISE_ROOT_DIR}/src/kubernetes.sh

OPTION="$1"
REBOOT="$2"

if [ "${OPTION}" == 'stop' ]; then
    print_message stdout 'stopping haproxy'
    ansible-playbook "${ELISE_ROOT_DIR}/ansible/playbooks/haproxy.yml" \
        --extra-vars "container_state=stopped recreate_container=no message=stopping"

    print_message stdout 'stopping all resources'
    "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" stop eslabs all
    ansible-playbook "${ELISE_ROOT_DIR}/ansible/playbooks/watchers.yml" --extra-vars "option=stop"

elif [ "${OPTION}" == 'shutdown' ]; then
    for host in ${LAB_SSH_LOGINS[@]}; do
        short_name=$(echo $host | awk -F '@' '{print $2}')
        print_message stdout "shutdown $short_name"
        ssh -F /tmp/ssh_config -i /tmp/id_rsa -o StrictHostKeyChecking=no -o LogLevel=ERROR $host 'sudo shutdown now -h' &> /dev/null &

    done

elif [ "${OPTION}" == 'destroy' ]; then
    print_message stdout 'destroying cluster'
    ansible-playbook "${ELISE_ROOT_DIR}/ansible/playbooks/k8s_cluster_destroy.yml"

    if [ ! -z "${REBOOT}" ]; then
        print_message stdout 'rebooting ansible hosts'
        ansible "~(k8s|watchers)" --become -m reboot

    fi

elif [ "${OPTION}" == 'deploy' ]; then
    print_message stdout 'installing kubernetes'
    ansible-playbook "${ELISE_ROOT_DIR}/ansible/playbooks/docker.yml"
    ansible-playbook "${ELISE_ROOT_DIR}/ansible/playbooks/kubernetes.yml"

    print_message stdout 'building cluster'
    ansible-playbook "${ELISE_ROOT_DIR}/ansible/playbooks/k8s_cluster_init.yml"

    print_message stdout 'deploying pod network' "${KUBE_POD_NETWORK}"
    "${ELISE_ROOT_DIR}/manifests/kube-flannel.sh" apply

    print_message stdout 'joining workers'
    ansible-playbook "${ELISE_ROOT_DIR}/ansible/playbooks/k8s_cluster_join.yml"

    print_message stdout 'waiting on kube-system'
    ensure_pods start 'kube-system'

    print_message stdout 'deploying ingress controller'
    "${ELISE_ROOT_DIR}/manifests/ingress-nginx.sh" apply
    ensure_pods start 'ingress-nginx'

    print_message stdout 'deploying namespace and ssl'
    "${ELISE_ROOT_DIR}/manifests/eslabs.sh" apply
    "${ELISE_ROOT_DIR}/manifests/hermes.sh" apply; "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" start eslabs hermes

    print_message stdout 'starting haproxy'
    ansible-playbook "${ELISE_ROOT_DIR}/ansible/playbooks/haproxy.yml" \
        --extra-vars "container_state=started recreate_container=no message=starting"

    print_message stdout 'deploying all other eslabs resources'
    "${ELISE_ROOT_DIR}/manifests/plex.sh" apply; "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" start eslabs plex
    "${ELISE_ROOT_DIR}/manifests/kharon.sh" apply; "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" start eslabs kharon
    ansible-playbook "${ELISE_ROOT_DIR}/ansible/playbooks/watchers.yml" --extra-vars "option=start"
    "${ELISE_ROOT_DIR}/manifests/hyperion.sh" apply; "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" start eslabs hyperion
    "${ELISE_ROOT_DIR}/manifests/filebrowser.sh" apply; "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" start eslabs filebrowser
    ansible-playbook "${ELISE_ROOT_DIR}/ansible/playbooks/nrpe.yml"
    "${ELISE_ROOT_DIR}/manifests/nagios.sh" apply; "${ELISE_ROOT_DIR}/scripts/kube_automator.sh" start eslabs nagios
    "${ELISE_ROOT_DIR}/manifests/pihole.sh" apply
    "${ELISE_ROOT_DIR}/manifests/ntopng.sh" apply
    ansible-playbook "${ELISE_ROOT_DIR}/ansible/playbooks/soteria.yml" --extra-vars "option=deploy"

fi
