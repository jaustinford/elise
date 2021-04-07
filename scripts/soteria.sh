#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/iscsi.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

export_color_codes
print_message stdout started "$(date)"
print_message stdout 'processing host' "$(hostname)"
ensure_root
kube_config /root "${LAB_FQDN}"
ensure_kubeconfig
ensure_iscsi_mountpath "${ISCSI_LOCAL_MOUNT_DIR}"
rotate_directory "${ISCSI_BACKUP_DIR}" tgz "${ISCSI_BACKUP_ROTATE_DAYS}"
find_active_deployments_from_array

for deployment in "${active_deployments[@]}"; do
    find_volumes_from_active_deployment "$deployment"
    kube_stop_deployment eslabs "$deployment" 1> /dev/null
    ensure_pod stop eslabs "$(pod_from_deployment eslabs $deployment wait)"

    for volume in "${active_volumes[@]}"; do
        check_if_k8s_is_using "$volume"
        ensure_chap "${ISCSI_CHAP_SESSION_USERNAME}" "${ISCSI_CHAP_SESSION_PASSWORD}"
        iscsi_discovery "${ISCSI_PORTAL}"
        find_target_with_vol "$volume" "${ISCSI_IQN}"
        check_if_volume_is_mounted "${ISCSI_LOCAL_MOUNT_DIR}"
        interact_target login "$volume" "${ISCSI_IQN}"
        mount_disk "$volume" "${ISCSI_LOCAL_MOUNT_DIR}"
        check_if_volume_is_not_mounted "${ISCSI_LOCAL_MOUNT_DIR}"
        create_backup "$volume" "${ISCSI_LOCAL_MOUNT_DIR}" "${ISCSI_BACKUP_DIR}"
        check_if_volume_is_not_mounted "${ISCSI_LOCAL_MOUNT_DIR}"
        dismount_disk "${ISCSI_LOCAL_MOUNT_DIR}"
        interact_target logout "$volume" "${ISCSI_IQN}"
        completed_volumes+=("$volume")

    done

    kube_start_deployment eslabs "$deployment" 1 1> /dev/null
    ensure_pod start eslabs "$(pod_from_deployment eslabs $deployment wait)"

done

generate_remaining_items "${completed_volumes[@]}"

if [ ! -z "${remaining_items}" ]; then
    for volume in "${remaining_items[@]}"; do
        check_if_k8s_is_using "$volume"
        ensure_chap "${ISCSI_CHAP_SESSION_USERNAME}" "${ISCSI_CHAP_SESSION_PASSWORD}"
        iscsi_discovery "${ISCSI_PORTAL}"
        find_target_with_vol "$volume" "${ISCSI_IQN}"
        check_if_volume_is_mounted "${ISCSI_LOCAL_MOUNT_DIR}"
        interact_target login "$volume" "${ISCSI_IQN}"
        mount_disk "$volume" "${ISCSI_LOCAL_MOUNT_DIR}"
        check_if_volume_is_not_mounted "${ISCSI_LOCAL_MOUNT_DIR}"
        create_backup "$volume" "${ISCSI_LOCAL_MOUNT_DIR}" "${ISCSI_BACKUP_DIR}"
        check_if_volume_is_not_mounted "${ISCSI_LOCAL_MOUNT_DIR}"
        dismount_disk "${ISCSI_LOCAL_MOUNT_DIR}"
        interact_target logout "$volume" "${ISCSI_IQN}"

    done

fi

print_message stdout finished "$(date)"
