#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.env"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/init.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

ssh_key
ssh_client_config
kube_config
check_cluster_from_wan_connectivity '6443'
