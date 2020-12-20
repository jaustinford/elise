ensure_chap () {
    print_message 'stdout' 'chap session user' "$1"
    if [ -z "$(egrep $1$ /etc/iscsi/iscsid.conf)" ]; then
        bash -c "cat <<EOF >> /etc/iscsi/iscsid.conf
node.session.auth.username = $1
node.session.auth.password = $2
EOF"

    fi
}

iscsi_discovery () {
    print_message 'stdout' 'discover portal' "$1"
    /usr/sbin/iscsiadm -m discovery -t sendtargets -p "$1" 1> /dev/null
}

check_if_volume_is_mounted () {
    if [ ! -z "$(df | grep $1)" ]; then
        print_message 'stderr' "$1 has a mounted volume"
        exit 1

    fi
}

check_if_volume_is_not_mounted () {
    if [ -z "$(df | grep $1)" ]; then
        print_message 'stderr' "$1 has no mounted volume"
        exit 1

    fi
}

find_target_with_vol () {
    if [ -z "$(/usr/sbin/iscsiadm -m node | cut -d ":" -f4 | egrep ^$1$)" ]; then
        print_message 'stderr' "target $1 not found"
        exit 1

    fi
}

interact_target () {
    if [ "$1" == 'login' ]; then
        action="log into target "

    elif [ "$1" == 'logout' ]; then
        action="log out of target "

    fi

    print_message 'stdout' "$action" "$3:$2"
    /usr/sbin/iscsiadm -m node --"$1" --target "$3:$2" 1> /dev/null
}

mount_disk () {
    target_disk=""
    while [ -z "$target_disk" ]; do
        target_disk=$(/usr/sbin/iscsiadm -m session -P 3 \
            | egrep '^Target|Attached scsi disk' \
            | grep "$1" -A1 \
            | grep 'Attached scsi disk' \
            | awk '{print $4}')

        sleep 1

    done

    print_message 'stdout' 'found device' "/dev/$target_disk"
    print_message 'stdout' 'mounting at' "$2"
    mkdir -p "$2"
    mount "/dev/$target_disk" "$2" 1> /dev/null
}


dismount_disk () {
    print_message 'stdout' 'unmounting' "$1"
    umount "$1" 1> /dev/null
}

create_backup() {
    backup_file="$1_$(date +%Y%m%d).tgz"
    print_message 'stdout' 'generating tarball' "$3/$backup_file"
    tar -C "$2" -czvf "$3/$backup_file" . 1> /dev/null
}
