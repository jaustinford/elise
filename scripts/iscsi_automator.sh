#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.ini"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"
. "${ELISE_ROOT_DIR}/src/iscsi.sh"

MODE="$1"
VOLUME="$2"

if [ "$#" == 2 ]; then
    ensure_chap "${ISCSI_CHAP_SESSION_USERNAME}" "${ISCSI_CHAP_SESSION_PASSWORD}"
    iscsi_discovery "${ISCSI_PORTAL}"
    find_target_with_vol "${VOLUME}" "${ISCSI_IQN}"
    check_if_k8s_is_using "${VOLUME}"

    if [ "${MODE}" == "mount" ]; then
        check_if_volume_is_mounted "${ISCSI_LOCAL_MOUNT_DIR}"
        interact_target 'login' "${VOLUME}" "${ISCSI_IQN}"
        mount_disk "${VOLUME}" "${ISCSI_LOCAL_MOUNT_DIR}"

    elif [ "${MODE}" == "dismount" ]; then
        check_if_volume_is_not_mounted "${ISCSI_LOCAL_MOUNT_DIR}"
        dismount_disk "${ISCSI_LOCAL_MOUNT_DIR}"
        interact_target 'logout' "${VOLUME}" "${ISCSI_IQN}"

    elif [ "${MODE}" == "backup" ]; then
        check_if_volume_is_not_mounted "${ISCSI_LOCAL_MOUNT_DIR}"
        create_backup "${VOLUME}" "${ISCSI_LOCAL_MOUNT_DIR}" "${ISCSI_BACKUP_DIR}"

    fi

fi
