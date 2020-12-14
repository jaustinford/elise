print_message () {
    if [ "$1" == 'stdout' ]; then
        if [ ! -z "$3" ]; then
            echo -e "[$SHELL_STDOUT_CODE*$ECHO_RESET] $2 : $3" 

        else
            echo -e "[$SHELL_STDOUT_CODE*$ECHO_RESET] $2" 

        fi

    elif [ "$1" == 'stderr' ]; then
        echo -e "[$SHELL_STDERR_CODE*$ECHO_RESET] $2" 

    fi
}

sed_edit () {
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
