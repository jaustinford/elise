#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/eslabs.ini"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/init.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

ssh_key
ssh_client_config
kube_config
