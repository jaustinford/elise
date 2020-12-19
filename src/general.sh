print_message () {
    TOTAL_LENGTH='30'
    KEY_LENGTH=$(echo "$2" | wc -c)
    PAD_LENGTH=$(echo $TOTAL_LENGTH-$KEY_LENGTH | bc -l)

    key="$2"
    for pad in $(seq 1 $PAD_LENGTH); do
        key+=" "

    done

    if [ "$1" == 'stdout' ]; then
        if [ ! -z "$3" ]; then
            echo -e "[$SHELL_STDOUT_CODE  OK   $ECHO_RESET] $key | $3"

        else
            echo -e "[$SHELL_STDOUT_CODE  OK   $ECHO_RESET] $key"

        fi

    elif [ "$1" == 'stderr' ]; then
        echo -e "[$SHELL_STDERR_CODE ERROR $ECHO_RESET] $key"

    fi
}

sed_edit () {
    print_message 'stdout' "switching $1" "$2"
    for file in $(grep -R --exclude-dir=.git "$1" . | cut -d':' -f1); do
        sed -i "s/$1/$2/g" "$file"

    done
}

find_operating_system () {
    operating_system=$(cat /etc/os-release \
        | grep PRETTY_NAME \
        | cut -d'=' -f2 \
        | sed 's/"//g')
}
