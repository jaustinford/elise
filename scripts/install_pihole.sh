#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.env"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/os.sh"

ensure_root
find_operating_system
install_pihole "$operating_system"
