#!/usr/bin/env bash

set -e

. "${SHELL_ROOT_DIR}/src/eslabs.env"
. "${SHELL_ROOT_DIR}/src/general.sh"
. "${SHELL_ROOT_DIR}/src/colors.sh"
. "${SHELL_ROOT_DIR}/src/init.sh"
. "${SHELL_ROOT_DIR}/src/git.sh"

ssh_key
