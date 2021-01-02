#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.env"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/ntopng.sh"
. "${ELISE_ROOT_DIR}/src/os.sh"

ensure_root
find_operating_system
install_ntopng "$operating_system" "${NTOPNG_REPO}"
ntopng_service
ntopng_webroot
