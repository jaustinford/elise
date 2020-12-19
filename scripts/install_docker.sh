#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.env"  
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/os.sh"

ensure_root
dont_run_if_inside_docker
find_operating_system
install_docker "$operating_system"
docker_systemd_driver
