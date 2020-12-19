#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.env"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/os.sh"

find_operating_system
print_rpi_temp "$operating_system"
