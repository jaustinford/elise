print_message () {
    TOTAL_LENGTH='30'
    KEY_LENGTH=$(echo "$2" | wc -c)
    PAD_LENGTH=`expr $TOTAL_LENGTH - $KEY_LENGTH`

    key="$2"
    for pad in $(seq 1 $PAD_LENGTH); do
        key+=" "

    done

    if [ "$1" == 'stdout' ]; then
        if [ ! -z "$3" ]; then
            echo -e "[$SHELL_STDOUT_CODE OK $ECHO_RESET] $key | $3"

        else
            echo -e "[$SHELL_STDOUT_CODE OK $ECHO_RESET] $key"

        fi

    elif [ "$1" == 'stderr' ]; then
        echo -e "[$SHELL_STDERR_CODE ERROR $ECHO_RESET] $key"

    fi
}

ensure_root () {
    if [ $(whoami) != "root" ]; then
        print_message 'stderr' 'must be run as root'
        exit 1

    fi
}

sed_edit () {
    print_message 'stdout' "switching $1" "$2"
    for file in $(grep -R --exclude-dir=.git "$1" . | cut -d':' -f1); do
        sed -i "s/$1/$2/g" "$file"

    done
}

permissions_and_dos_line_endings () {
    print_message 'stdout' 'setting permissions' "$1"
    chmod -R 750 "$1"
    chown -R root:root "$1"

    print_message 'stdout' 'convert line endings' "$1"
    find "$1" -type f ! -path "*/.git/*" ! -path "*/.kube/*" -exec dos2unix {} \; &> /dev/null
}

rotate_directory () {
    print_message 'stdout' "rotate '.$3' older than" "$2 days"
    find "$1" -type f -name \*"$3" -mtime +"$2" -exec rm -f {} \; 1> /dev/null
}
