ECHO_TYPE='bold'

if [ "${ECHO_TYPE}" == 'bold' ]; then ECHO_START='\033['
elif [ "${ECHO_TYPE}" == 'regular' ]; then ECHO_START='\e['
fi

ECHO_WHITE="${ECHO_START}1;37m"
ECHO_BLUE="${ECHO_START}1;34m"
ECHO_GREEN="${ECHO_START}1;32m"
ECHO_CYAN="${ECHO_START}1;36m"
ECHO_RED="${ECHO_START}1;31m"
ECHO_PURPLE="${ECHO_START}1;35m"
ECHO_YELLOW="${ECHO_START}1;33m"
ECHO_DARKGRAY="${ECHO_START}1;30m"
ECHO_LIGHTGRAY="${ECHO_START}0;37m"
ECHO_RESET="${ECHO_START}00m"

if [ "${SHELL_STDOUT_COLOR}" == 'white' ]; then SHELL_STDOUT_CODE=$ECHO_WHITE
elif [ "${SHELL_STDOUT_COLOR}" == 'blue' ]; then SHELL_STDOUT_CODE=$ECHO_BLUE
elif [ "${SHELL_STDOUT_COLOR}" == 'green' ]; then SHELL_STDOUT_CODE=$ECHO_GREEN
elif [ "${SHELL_STDOUT_COLOR}" == 'cyan' ]; then SHELL_STDOUT_CODE=$ECHO_CYAN
elif [ "${SHELL_STDOUT_COLOR}" == 'red' ]; then SHELL_STDOUT_CODE=$ECHO_RED
elif [ "${SHELL_STDOUT_COLOR}" == 'purple' ]; then SHELL_STDOUT_CODE=$ECHO_PURPLE
elif [ "${SHELL_STDOUT_COLOR}" == 'yellow' ]; then SHELL_STDOUT_CODE=$ECHO_YELLOW
elif [ "${SHELL_STDOUT_COLOR}" == 'darkgray' ]; then SHELL_STDOUT_CODE=$ECHO_DARKGRAY
elif [ "${SHELL_STDOUT_COLOR}" == 'lightgray' ]; then SHELL_STDOUT_CODE=$ECHO_LIGHTGRAY
fi

if [ "${SHELL_STDERR_COLOR}" == 'white' ]; then SHELL_STDERR_CODE=$ECHO_WHITE
elif [ "${SHELL_STDERR_COLOR}" == 'blue' ]; then SHELL_STDERR_CODE=$ECHO_BLUE
elif [ "${SHELL_STDERR_COLOR}" == 'green' ]; then SHELL_STDERR_CODE=$ECHO_GREEN
elif [ "${SHELL_STDERR_COLOR}" == 'cyan' ]; then SHELL_STDERR_CODE=$ECHO_CYAN
elif [ "${SHELL_STDERR_COLOR}" == 'red' ]; then SHELL_STDERR_CODE=$ECHO_RED
elif [ "${SHELL_STDERR_COLOR}" == 'purple' ]; then SHELL_STDERR_CODE=$ECHO_PURPLE
elif [ "${SHELL_STDERR_COLOR}" == 'yellow' ]; then SHELL_STDERR_CODE=$ECHO_YELLOW
elif [ "${SHELL_STDERR_COLOR}" == 'darkgray' ]; then SHELL_STDERR_CODE=$ECHO_DARKGRAY
elif [ "${SHELL_STDERR_COLOR}" == 'lightgray' ]; then SHELL_STDERR_CODE=$ECHO_LIGHTGRAY
fi

if [ "${SHELL_USER_PROMPT_COLOR}" == 'white' ]; then SHELL_USER_PROMPT_CODE=$ECHO_WHITE
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'blue' ]; then SHELL_USER_PROMPT_CODE=$ECHO_BLUE
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'green' ]; then SHELL_USER_PROMPT_CODE=$ECHO_GREEN
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'cyan' ]; then SHELL_USER_PROMPT_CODE=$ECHO_CYAN
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'red' ]; then SHELL_USER_PROMPT_CODE=$ECHO_RED
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'purple' ]; then SHELL_USER_PROMPT_CODE=$ECHO_PURPLE
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'yellow' ]; then SHELL_USER_PROMPT_CODE=$ECHO_YELLOW
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'darkgray' ]; then SHELL_USER_PROMPT_CODE=$ECHO_DARKGRAY
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'lightgray' ]; then SHELL_USER_PROMPT_CODE=$ECHO_LIGHTGRAY
fi

if [ "${SHELL_HOST_PROMPT_COLOR}" == 'white' ]; then SHELL_HOST_PROMPT_CODE=$ECHO_WHITE
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'blue' ]; then SHELL_HOST_PROMPT_CODE=$ECHO_BLUE
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'green' ]; then SHELL_HOST_PROMPT_CODE=$ECHO_GREEN
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'cyan' ]; then SHELL_HOST_PROMPT_CODE=$ECHO_CYAN
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'red' ]; then SHELL_HOST_PROMPT_CODE=$ECHO_RED
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'purple' ]; then SHELL_HOST_PROMPT_CODE=$ECHO_PURPLE
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'yellow' ]; then SHELL_HOST_PROMPT_CODE=$ECHO_YELLOW
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'darkgray' ]; then SHELL_HOST_PROMPT_CODE=$ECHO_DARKGRAY
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'lightgray' ]; then SHELL_HOST_PROMPT_CODE=$ECHO_LIGHTGRAY
fi

if [ "${SHELL_CWD_PROMPT_COLOR}" == 'white' ]; then SHELL_CWD_PROMPT_CODE=$ECHO_WHITE
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'blue' ]; then SHELL_CWD_PROMPT_CODE=$ECHO_BLUE
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'green' ]; then SHELL_CWD_PROMPT_CODE=$ECHO_GREEN
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'cyan' ]; then SHELL_CWD_PROMPT_CODE=$ECHO_CYAN
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'red' ]; then SHELL_CWD_PROMPT_CODE=$ECHO_RED
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'purple' ]; then SHELL_CWD_PROMPT_CODE=$ECHO_PURPLE
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'yellow' ]; then SHELL_CWD_PROMPT_CODE=$ECHO_YELLOW
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'darkgray' ]; then SHELL_CWD_PROMPT_CODE=$ECHO_DARKGRAY
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'lightgray' ]; then SHELL_CWD_PROMPT_CODE=$ECHO_LIGHTGRAY
fi

if [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'white' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE=$ECHO_WHITE
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'blue' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE=$ECHO_BLUE
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'green' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE=$ECHO_GREEN
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'cyan' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE=$ECHO_CYAN
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'red' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE=$ECHO_RED
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'purple' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE=$ECHO_PURPLE
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'yellow' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE=$ECHO_YELLOW
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'darkgray' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE=$ECHO_DARKGRAY
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'lightgray' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE=$ECHO_LIGHTGRAY
fi

if [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'white' ]; then SHELL_KUBE_DISPLAY_KEY_CODE=$ECHO_WHITE
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'blue' ]; then SHELL_KUBE_DISPLAY_KEY_CODE=$ECHO_BLUE
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'green' ]; then SHELL_KUBE_DISPLAY_KEY_CODE=$ECHO_GREEN
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'cyan' ]; then SHELL_KUBE_DISPLAY_KEY_CODE=$ECHO_CYAN
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'red' ]; then SHELL_KUBE_DISPLAY_KEY_CODE=$ECHO_RED
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'purple' ]; then SHELL_KUBE_DISPLAY_KEY_CODE=$ECHO_PURPLE
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'yellow' ]; then SHELL_KUBE_DISPLAY_KEY_CODE=$ECHO_YELLOW
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'darkgray' ]; then SHELL_KUBE_DISPLAY_KEY_CODE=$ECHO_DARKGRAY
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'lightgray' ]; then SHELL_KUBE_DISPLAY_KEY_CODE=$ECHO_LIGHTGRAY
fi

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
            echo -e "  [ ${SHELL_STDOUT_CODE}OK${ECHO_RESET} - ${SHELL_STDOUT_CODE}$(date '+%Y.%m.%d-%H:%M:%S')${ECHO_RESET} ] ${SHELL_HOST_PROMPT_CODE}$key${ECHO_RESET} | ${SHELL_CWD_PROMPT_CODE}$3${ECHO_RESET}"

        else
            echo -e "  [ ${SHELL_STDOUT_CODE}OK${ECHO_RESET} - ${SHELL_STDOUT_CODE}$(date '+%Y.%m.%d-%H:%M:%S')${ECHO_RESET} ] ${SHELL_HOST_PROMPT_CODE}$key${ECHO_RESET}"

        fi

    elif [ "$1" == 'stderr' ]; then
        if [ ! -z "$3" ]; then
            echo -e " [ ${SHELL_STDERR_CODE}ERR${ECHO_RESET} - ${SHELL_STDERR_CODE}$(date '+%Y.%m.%d-%H:%M:%S')${ECHO_RESET} ] ${SHELL_HOST_PROMPT_CODE}$key${ECHO_RESET} | ${SHELL_CWD_PROMPT_CODE}$3${ECHO_RESET}"

        else
            echo -e " [ ${SHELL_STDERR_CODE}ERR${ECHO_RESET} - ${SHELL_STDERR_CODE}$(date '+%Y.%m.%d-%H:%M:%S')${ECHO_RESET} ] ${SHELL_HOST_PROMPT_CODE}$key${ECHO_RESET}"

        fi

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
