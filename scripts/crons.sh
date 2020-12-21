#!/usr/bin/env bash

set -e 

. "${ELISE_ROOT_DIR}/src/elise.env"  
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/os.sh"

ensure_root
dont_run_if_inside_docker
find_operating_system
install_cron "$operating_system"

if [ "$(hostname)" == "${ISCSI_CRON_HOST}" ]; then
    print_message 'stdout' 'copy cron jobs' "$(hostname)"
    cp "${ELISE_ROOT_DIR}/crons/escrons" /etc/cron.d/escrons
    chmod 644 /etc/cron.d/escrons
    
    print_message 'stdout' "reloading $cron_service"
    systemctl reload "$cron_service"

fi
