#!/usr/bin/env bash

set -e

. "${SHELL_ROOT_DIR}/src/eslabs.ini"
. "${SHELL_ROOT_DIR}/src/general.sh"
. "${SHELL_ROOT_DIR}/src/colors.sh"
. "${SHELL_ROOT_DIR}/src/init.sh"
. "${SHELL_ROOT_DIR}/src/kubernetes.sh"

ssh_key
ssh_client_config
kube_config
