#!/usr/bin/env bash

 set -eu

. "${ELISE_ROOT_DIR}/src/elise.env"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/os.sh"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

dont_run_if_inside_docker
ensure_root
download_kubectl
