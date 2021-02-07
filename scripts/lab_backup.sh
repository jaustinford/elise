#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/iscsi.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

print_message 'stdout' 'started' "$(date)"
print_message 'stdout' 'processing host' "$(hostname)"

ensure_root
kube_config '/root'
ensure_kubeconfig
ensure_iscsi_mountpath "${ISCSI_LOCAL_MOUNT_DIR}"
rotate_directory "${ISCSI_BACKUP_DIR}" "${ISCSI_BACKUP_ROTATE_DAYS}" 'tgz'
find_deployments_from_array "${ISCSI_BACKUP_VOLUMES[@]}"

for deployment in $unique_deployments; do
    find_namespace_from_deployment "$deployment"
    kube_stop_deployment  "$namespace" "$deployment"

done

for deployment in $unique_deployments; do
    wait_for_pod_to 'stop' "$deployment"

done

for volume in "${ISCSI_BACKUP_VOLUMES[@]}"; do
    check_if_k8s_is_using "$volume"
    ensure_chap "${ISCSI_CHAP_SESSION_USERNAME}" "${ISCSI_CHAP_SESSION_PASSWORD}"
    iscsi_discovery "${ISCSI_PORTAL}"
    find_target_with_vol "$volume" "${ISCSI_IQN}"
    check_if_volume_is_mounted "${ISCSI_LOCAL_MOUNT_DIR}"
    interact_target 'login' "$volume" "${ISCSI_IQN}"
    mount_disk "$volume" "${ISCSI_LOCAL_MOUNT_DIR}"
    check_if_volume_is_not_mounted "${ISCSI_LOCAL_MOUNT_DIR}"
    create_backup "$volume" "${ISCSI_LOCAL_MOUNT_DIR}" "${ISCSI_BACKUP_DIR}"
    check_if_volume_is_not_mounted "${ISCSI_LOCAL_MOUNT_DIR}"
    dismount_disk "${ISCSI_LOCAL_MOUNT_DIR}"
    interact_target 'logout' "$volume" "${ISCSI_IQN}"

done

for deployment in $unique_deployments; do
    find_namespace_from_deployment "$deployment"
    kube_start_deployment "$namespace" "$deployment" '1'

done

for deployment in $unique_deployments; do
    wait_for_pod_to 'start' "$deployment"

done

print_message 'stdout' 'finished' "$(date)"
