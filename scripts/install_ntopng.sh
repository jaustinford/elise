#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.env"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/ntopng.sh"
. "${ELISE_ROOT_DIR}/src/os.sh"

if [ "$(hostname)" != 'netmon.labs.elysianskies.com' ]; then
    print_message 'stderr' 'host match failed!'
    exit 1

fi

ensure root
find_operating_system
install_ntopng "$operating_system" "${NTOPNG_REPO}"
ntopng_webroot
ntopng_service
