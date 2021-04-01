####################################################
# dependencies
####################################################

ensure_chap () {
    chap_user="$1"
    chap_password="$2"

    print_message stdout 'chap session user' "$chap_user"
    if [ -z "$(egrep $chap_user$ /etc/iscsi/iscsid.conf)" ]; then
        cat <<EOF >> /etc/iscsi/iscsid.conf
node.session.auth.username = $chap_user
node.session.auth.password = $chap_password
EOF

    fi
}

ensure_iscsi_mountpath () {
    mount_dir="$1"

    if [ ! -d "$mount_dir" ]; then
        mkdir -p "$mount_dir"

    fi
}

####################################################
# error handles
####################################################

check_if_volume_is_mounted () {
    mount_dir="$1"

    if [ ! -z "$(df | grep $mount_dir)" ]; then
        print_message stderr "$mount_dir has a mounted volume"
        exit 1

    fi
}

check_if_volume_is_not_mounted () {
    mount_dir="$1"

    if [ -z "$(df | grep $mount_dir)" ]; then
        print_message stderr "$mount_dir has no mounted volume"
        exit 1

    fi
}

####################################################
# open-iscsi
####################################################

interact_target () {
    iscsi_mode="$1"
    iscsi_volume="$2"
    iscsi_iqn="$3"

    if [ "$iscsi_mode" == 'login' ]; then action='log into target '
    elif [ "$iscsi_mode" == 'logout' ]; then action='log out of target '
    fi

    print_message stdout "$action" "$iscsi_iqn:$iscsi_volume"
    iscsiadm -m node "--$iscsi_mode" --target "$iscsi_iqn:$iscsi_volume" 1> /dev/null
}

iscsi_discovery () {
    portal="$1"

    print_message stdout 'discover portal' "$portal"
    iscsiadm -m discovery -t sendtargets -p "$portal" 1> /dev/null
}

find_target_with_vol () {
    volume="$1"

    if [ -z "$(iscsiadm -m node | cut -d ":" -f4 | egrep ^$volume$)" ]; then
        print_message stderr "target $volume not found"
        exit 1

    fi
}

mount_disk () {
    mounted_fs="$1"
    mount_dir="$2"
    target_disk=""

    while [ -z "$target_disk" ]; do
        target_disk="$(iscsiadm -m session -P 3 \
            | egrep '^Target|Attached scsi disk' \
            | grep "$mounted_fs" -A1 \
            | grep 'Attached scsi disk' \
            | awk '{print $4}')"

        sleep 1

    done

    print_message stdout 'found device' "/dev/$target_disk"
    print_message stdout 'mounting at' "$mount_dir"
    mkdir -p "$mount_dir"
    mount "/dev/$target_disk" "$mount_dir" 1> /dev/null
}

####################################################
# soteria
####################################################

dismount_disk () {
    mounted_disk="$1"

    print_message stdout 'unmounting disk' "$mounted_disk"
    umount "$mounted_disk" 1> /dev/null
}

create_backup () {
    backup_name="$1"
    source_dir="$2"
    destination_dir="$3"

    backup_file="$backup_name"_"$(date +%Y%m%d).tgz"
    print_message stdout 'generating tarball' "$destination_dir/$backup_file"
    tar -C "$source_dir" -czvf "$destination_dir/$backup_file" . 1> /dev/null
}

generate_remaining_items () {
    remaining_items=()
    completed_items="$@"

    for total_item in ${ISCSI_BACKUP_VOLUMES[@]}; do
        copy='true'
        for completed_item in ${completed_items[@]}; do
            if [ "$total_item" == "$completed_item" ]; then
                copy='false'
                break

            fi

        done

        if [ "$copy" == 'true' ]; then
            remaining_items+=("$total_item")

        fi

    done
}
