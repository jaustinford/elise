#!/usr/bin/env bash

set -e

. "${SHELL_ROOT_DIR}/src/eslabs.ini"
. "${SHELL_ROOT_DIR}/src/general.sh"
. "${SHELL_ROOT_DIR}/src/colors.sh"
. "${SHELL_ROOT_DIR}/src/ntopng.sh"

if [ "$(hostname)" != 'netmon.labs.elysianskies.com' ]; then
    print_message 'stderr' 'host match failed!'
    exit 1

fi

ntopng_install "${NTOPNG_REPO}"
ntopng_webroot
ntopng_service
