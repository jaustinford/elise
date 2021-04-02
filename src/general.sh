####################################################
# shell coloring
####################################################

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

if [ "${SHELL_STDOUT_COLOR}" == 'white' ]; then SHELL_STDOUT_CODE="${ECHO_WHITE}"
elif [ "${SHELL_STDOUT_COLOR}" == 'blue' ]; then SHELL_STDOUT_CODE="${ECHO_BLUE}"
elif [ "${SHELL_STDOUT_COLOR}" == 'green' ]; then SHELL_STDOUT_CODE="${ECHO_GREEN}"
elif [ "${SHELL_STDOUT_COLOR}" == 'cyan' ]; then SHELL_STDOUT_CODE="${ECHO_CYAN}"
elif [ "${SHELL_STDOUT_COLOR}" == 'red' ]; then SHELL_STDOUT_CODE="${ECHO_RED}"
elif [ "${SHELL_STDOUT_COLOR}" == 'purple' ]; then SHELL_STDOUT_CODE="${ECHO_PURPLE}"
elif [ "${SHELL_STDOUT_COLOR}" == 'yellow' ]; then SHELL_STDOUT_CODE="${ECHO_YELLOW}"
elif [ "${SHELL_STDOUT_COLOR}" == 'darkgray' ]; then SHELL_STDOUT_CODE="${ECHO_DARKGRAY}"
elif [ "${SHELL_STDOUT_COLOR}" == 'lightgray' ]; then SHELL_STDOUT_CODE="${ECHO_LIGHTGRAY}"
fi

if [ "${SHELL_STDERR_COLOR}" == 'white' ]; then SHELL_STDERR_CODE="${ECHO_WHITE}"
elif [ "${SHELL_STDERR_COLOR}" == 'blue' ]; then SHELL_STDERR_CODE="${ECHO_BLUE}"
elif [ "${SHELL_STDERR_COLOR}" == 'green' ]; then SHELL_STDERR_CODE="${ECHO_GREEN}"
elif [ "${SHELL_STDERR_COLOR}" == 'cyan' ]; then SHELL_STDERR_CODE="${ECHO_CYAN}"
elif [ "${SHELL_STDERR_COLOR}" == 'red' ]; then SHELL_STDERR_CODE="${ECHO_RED}"
elif [ "${SHELL_STDERR_COLOR}" == 'purple' ]; then SHELL_STDERR_CODE="${ECHO_PURPLE}"
elif [ "${SHELL_STDERR_COLOR}" == 'yellow' ]; then SHELL_STDERR_CODE="${ECHO_YELLOW}"
elif [ "${SHELL_STDERR_COLOR}" == 'darkgray' ]; then SHELL_STDERR_CODE="${ECHO_DARKGRAY}"
elif [ "${SHELL_STDERR_COLOR}" == 'lightgray' ]; then SHELL_STDERR_CODE="${ECHO_LIGHTGRAY}"
fi

if [ "${SHELL_USER_PROMPT_COLOR}" == 'white' ]; then SHELL_USER_PROMPT_CODE="${ECHO_WHITE}"
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'blue' ]; then SHELL_USER_PROMPT_CODE="${ECHO_BLUE}"
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'green' ]; then SHELL_USER_PROMPT_CODE="${ECHO_GREEN}"
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'cyan' ]; then SHELL_USER_PROMPT_CODE="${ECHO_CYAN}"
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'red' ]; then SHELL_USER_PROMPT_CODE="${ECHO_RED}"
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'purple' ]; then SHELL_USER_PROMPT_CODE="${ECHO_PURPLE}"
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'yellow' ]; then SHELL_USER_PROMPT_CODE="${ECHO_YELLOW}"
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'darkgray' ]; then SHELL_USER_PROMPT_CODE="${ECHO_DARKGRAY}"
elif [ "${SHELL_USER_PROMPT_COLOR}" == 'lightgray' ]; then SHELL_USER_PROMPT_CODE="${ECHO_LIGHTGRAY}"
fi

if [ "${SHELL_HOST_PROMPT_COLOR}" == 'white' ]; then SHELL_HOST_PROMPT_CODE="${ECHO_WHITE}"
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'blue' ]; then SHELL_HOST_PROMPT_CODE="${ECHO_BLUE}"
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'green' ]; then SHELL_HOST_PROMPT_CODE="${ECHO_GREEN}"
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'cyan' ]; then SHELL_HOST_PROMPT_CODE="${ECHO_CYAN}"
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'red' ]; then SHELL_HOST_PROMPT_CODE="${ECHO_RED}"
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'purple' ]; then SHELL_HOST_PROMPT_CODE="${ECHO_PURPLE}"
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'yellow' ]; then SHELL_HOST_PROMPT_CODE="${ECHO_YELLOW}"
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'darkgray' ]; then SHELL_HOST_PROMPT_CODE="${ECHO_DARKGRAY}"
elif [ "${SHELL_HOST_PROMPT_COLOR}" == 'lightgray' ]; then SHELL_HOST_PROMPT_CODE="${ECHO_LIGHTGRAY}"
fi

if [ "${SHELL_CWD_PROMPT_COLOR}" == 'white' ]; then SHELL_CWD_PROMPT_CODE="${ECHO_WHITE}"
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'blue' ]; then SHELL_CWD_PROMPT_CODE="${ECHO_BLUE}"
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'green' ]; then SHELL_CWD_PROMPT_CODE="${ECHO_GREEN}"
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'cyan' ]; then SHELL_CWD_PROMPT_CODE="${ECHO_CYAN}"
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'red' ]; then SHELL_CWD_PROMPT_CODE="${ECHO_RED}"
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'purple' ]; then SHELL_CWD_PROMPT_CODE="${ECHO_PURPLE}"
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'yellow' ]; then SHELL_CWD_PROMPT_CODE="${ECHO_YELLOW}"
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'darkgray' ]; then SHELL_CWD_PROMPT_CODE="${ECHO_DARKGRAY}"
elif [ "${SHELL_CWD_PROMPT_COLOR}" == 'lightgray' ]; then SHELL_CWD_PROMPT_CODE="${ECHO_LIGHTGRAY}"
fi

if [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'white' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE="${ECHO_WHITE}"
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'blue' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE="${ECHO_BLUE}"
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'green' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE="${ECHO_GREEN}"
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'cyan' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE="${ECHO_CYAN}"
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'red' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE="${ECHO_RED}"
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'purple' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE="${ECHO_PURPLE}"
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'yellow' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE="${ECHO_YELLOW}"
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'darkgray' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE="${ECHO_DARKGRAY}"
elif [ "${SHELL_KUBE_DISPLAY_BANNER_COLOR}" == 'lightgray' ]; then SHELL_KUBE_DISPLAY_BANNER_CODE="${ECHO_LIGHTGRAY}"
fi

if [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'white' ]; then SHELL_KUBE_DISPLAY_KEY_CODE="${ECHO_WHITE}"
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'blue' ]; then SHELL_KUBE_DISPLAY_KEY_CODE="${ECHO_BLUE}"
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'green' ]; then SHELL_KUBE_DISPLAY_KEY_CODE="${ECHO_GREEN}"
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'cyan' ]; then SHELL_KUBE_DISPLAY_KEY_CODE="${ECHO_CYAN}"
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'red' ]; then SHELL_KUBE_DISPLAY_KEY_CODE="${ECHO_RED}"
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'purple' ]; then SHELL_KUBE_DISPLAY_KEY_CODE="${ECHO_PURPLE}"
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'yellow' ]; then SHELL_KUBE_DISPLAY_KEY_CODE="${ECHO_YELLOW}"
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'darkgray' ]; then SHELL_KUBE_DISPLAY_KEY_CODE="${ECHO_DARKGRAY}"
elif [ "${SHELL_KUBE_DISPLAY_KEY_COLOR}" == 'lightgray' ]; then SHELL_KUBE_DISPLAY_KEY_CODE="${ECHO_LIGHTGRAY}"
fi

####################################################
# messages
####################################################

print_message () {
    print_message_mode="$1"
    message_1="$2"
    message_2="$3"

    TOTAL_LENGTH='30'
    KEY_LENGTH="$(echo "$message_1" | wc -c)"
    PAD_LENGTH="$(expr "${TOTAL_LENGTH}" - "${KEY_LENGTH}")"

    for pad in $(seq 1 "${PAD_LENGTH}"); do
        message_1+=' '

    done

    if [ "$print_message_mode" == 'stdout' ]; then
        if [ ! -z "$message_2" ]; then
            echo -e "  ${SHELL_STDOUT_CODE}OUT${ECHO_RESET} [ ${SHELL_CWD_PROMPT_CODE}$(date '+%Y.%m.%d - %H:%M:%S')${ECHO_RESET} ] ${SHELL_HOST_PROMPT_CODE}$message_1${ECHO_RESET} | ${SHELL_CWD_PROMPT_CODE}$message_2${ECHO_RESET}"

        else
            echo -e "  ${SHELL_STDOUT_CODE}OUT${ECHO_RESET} [ ${SHELL_CWD_PROMPT_CODE}$(date '+%Y.%m.%d - %H:%M:%S')${ECHO_RESET} ] ${SHELL_HOST_PROMPT_CODE}$message_1${ECHO_RESET}"

        fi

    elif [ "$print_message_mode" == 'stderr' ]; then
        if [ ! -z "$message_2" ]; then
            echo -e "  ${SHELL_STDERR_CODE}ERR${ECHO_RESET} [ ${SHELL_STDERR_CODE}$(date '+%Y.%m.%d - %H:%M:%S')${ECHO_RESET} ] ${SHELL_STDERR_CODE}$message_1${ECHO_RESET} | ${SHELL_STDERR_CODE}$message_2${ECHO_RESET}"

        else
            echo -e "  ${SHELL_STDERR_CODE}ERR${ECHO_RESET} [ ${SHELL_STDERR_CODE}$(date '+%Y.%m.%d - %H:%M:%S')${ECHO_RESET} ] ${SHELL_STDERR_CODE}$message_1${ECHO_RESET}"

        fi

    fi
}

####################################################
# project management
####################################################

rotate_directory () {
    rotate_directory="$1"
    file_extension="$2"
    rotate_in_days="$3"

    print_message stdout "deleting files after $rotate_in_days days" "$rotate_directory/*.$file_extension"
    find "$rotate_directory" -type f -name \*"$file_extension" -mtime +"$rotate_in_days" -exec rm -f {} \;
}

vars_update () {
    var_key="$1"
    var_value="$2"
    found='false'

    for item in $(cat "${ELISE_ROOT_DIR}/src/elise.sh" | cut -d'=' -f1); do
        if [ "$var_key" == "$item" ]; then
            found='true'

        fi

    done

    if [ "$found" == 'true' ]; then
        print_message stdout 'updating variable' "$var_key='$var_value'"
        sed -i -E "s/^$var_key.*$/$var_key='$var_value'/g" "${ELISE_ROOT_DIR}/src/elise.sh"

    else
        print_message stderr "key '$var_key' was not found in ${ELISE_ROOT_DIR}/src/elise.sh"

    fi
}

sed_edit () {
    old_string="$1"
    new_string="$2"

    print_message stdout "switching $old_string" "$new_string"
    for file in $(grep -R --exclude-dir=.git --exclude-dir=.kube --exclude=.bash_history "$old_string" . | cut -d':' -f1); do
        echo "$file"
        # sed -i "s/$old_string/$new_string/g" "$file"

    done
}

permissions_and_dos_line_endings () {
    directory="$1"

    print_message stdout 'setting permissions' "$directory"
    chmod -R 750 "$directory"
    chmod 600 "${ELISE_ROOT_DIR}/.vault.txt"
    chown -R root:root "$directory"
    print_message stdout 'convert line endings' "$directory"
    find "$directory" -type f ! -path "*/.git/*" ! -path "*/.kube/*" -exec dos2unix -q {} \; 1> /dev/null
}

ensure_dropoff_folder () {
    if [ ! -d "${ELISE_ROOT_DIR}/dropoff" ]; then
        print_message stdout 'creating dropoff directory' "${ELISE_ROOT_DIR}/dropoff"
        mkdir -p "${ELISE_ROOT_DIR}/dropoff"

    fi
}

print_expressvpn_servers () {
    for item in $(cat "${ELISE_ROOT_DIR}/files/expressvpn_servers.txt"); do
        if [ "$item" == "${KHARON_EXPRESSVPN_SERVER}" ]; then
            print_message stdout "$item" 'configured server'

        else
            print_message stdout "$item"

        fi

    done
}

####################################################
# init tasks
####################################################

ssh_key () {
    print_message stdout 'configure user ssh key' /tmp/id_rsa
    echo "${LAB_USER_AUSTIN_SSH_KEY}" | base64 -d > /tmp/id_rsa
    chmod 600 /tmp/id_rsa
}

ssh_client_config () {
    print_message stdout 'generate client ssh config' /tmp/ssh_config
    cat <<EOF > /tmp/ssh_config
Host kube0* dns
    User ubuntu

Host watcher0* eva
    User austin

Host netmon
    User pi

Host tvault
    User sshd
EOF
    chmod 600 /tmp/ssh_config
}

add_local_dns () {
    dns_search_domain="$1"

    print_message stdout 'generate local dns' /etc/resolv.conf
    if [ -z "$(grep kube00 /etc/hosts)" ]; then
        echo '172.16.17.20    kube00 kube00.labs.elysianskies.com' >> /etc/hosts

    fi

    cat << EOF > /etc/resolv.conf
nameserver 172.16.17.10
search ${LAB_FQDN}
EOF
}

greeting () {
    user="$1"

    chour="$(date \
        | awk '{print $4}' \
        | cut -d':' -f1)"

    if [ "$chour" -ge 0 ] && [ "$chour" -lt 5 ]; then message="it's way past your bed time"
    elif [ "$chour" -ge 5 ] && [ "$chour" -lt 7 ]; then message='the early bird gets the worm'
    elif [ "$chour" -ge 7 ] && [ "$chour" -lt 12 ]; then message='good morning'
    elif [ "$chour" -ge 12 ] && [ "$chour" -lt 17 ]; then message='good afternoon'
    elif [ "$chour" -ge 17 ] && [ "$chour" -lt 22 ]; then message='good evening'
    elif [ "$chour" -ge 22 ] && [ "$chour" -lt 24 ]; then message="it's getting late"
    fi

    echo -e "                  $message$SHELL_USER_PROMPT_CODE $user $ECHO_RESET\n"
}

####################################################
# connection tests
####################################################

curl_test () {
    message="$1"
    http_mode="$2"
    domain="$3"
    web_path="$4"

    http_response="$(curl -siL "$http_mode://$domain$web_path" \
        | egrep ^HTTP\/ \
        | tail -1 \
        | awk '{print $2}')"

    if [ "$http_response" == '200' ]; then
        print_message stdout "curl $http_response $message" "$2://$3$4"

    else
        print_message stderr "curl $http_response $message" "$2://$3$4"

    fi
}

nmap_scan () {
    host="$1"
    port="$2"

    state="$(nmap -Pn -p "$port" "$host" \
        | egrep "^$port\/(tcp|udp)" \
        | awk '{print $2}')"

    if [ "$state" == 'open' ]; then
        print_message stdout 'nmap reports port is open' "$host:$port"

    else
        print_message stderr "nmap reports port is $state" "$host:$port"

    fi
}

ssl_reader () {
    domain="$1"
    port="$2"

    ssl_crt="$(echo \
        | openssl s_client -connect "$domain:$port" 2> /dev/null \
        | openssl x509 2> /dev/null)"

    if [ ! -z "$ssl_crt" ]; then
        issuer="$(echo "$ssl_crt" | openssl x509 -noout -issuer)"
        serial="$(echo "$ssl_crt" | openssl x509 -noout -serial)"
        enddate="$(echo "$ssl_crt" | openssl x509 -noout -enddate)"
        subject="$(echo "$ssl_crt" | openssl x509 -noout -subject)"
        subjectAltName="$(echo "$ssl_crt" \
            | openssl x509 -noout -ext subjectAltName \
            | egrep -o 'DNS:.*$')"

        print_message stdout 'ssl certificate found for' "https://$domain:$port"
        print_message stdout 'ssl ca author' "$issuer"
        print_message stdout 'ssl serial number' "$serial"
        print_message stdout 'ssl expiration date' "$enddate"
        print_message stdout 'ssl subject cn' "$subject"
        print_message stdout 'ssl subject alt names' "$subjectAltName"

    else
        print_message stderr 'no certificate found for' "https://$domain:$port"

    fi
}

####################################################
# error handles
####################################################

ensure_root () {
    if [ "$(whoami)" != 'root' ]; then
        print_message stderr 'must be run as root'
        exit 1

    fi
}

vars_ensure () {
    filestate="$1"

    chmod 600 "${ELISE_ROOT_DIR}/.vault.txt" 2> /dev/null

    if [ "$filestate" == 'encrypted' ]; then
        while [ "$(head -1 ${ELISE_ROOT_DIR}/src/elise.sh)" != '$ANSIBLE_VAULT;1.1;AES256' ]; do
            print_message stdout 'encrypting variables' "${ELISE_ROOT_DIR}/src/elise.sh"
            ansible-vault encrypt --vault-password-file=~/.vault.txt "${ELISE_ROOT_DIR}/src/elise.sh" 2> /dev/null

        done

    elif [ "$filestate" == 'decrypted' ]; then
        attempt="$(ansible-vault decrypt --vault-password-file=~/.vault.txt ${ELISE_ROOT_DIR}/src/elise.sh 2>&1)"

        if [ -z "${ELISE_PROFILE}" ]; then
            if [ ! -z "$attempt" ]; then
                echo "$(date '+%Y.%m.%d - %H:%M:%S') $attempt"

            else
                echo "$(date '+%Y.%m.%d - %H:%M:%S') successfully decrypted ${ELISE_ROOT_DIR}/src/elise.sh"

            fi

        fi

        if [ "$attempt" == "ERROR! Decryption failed (no vault secrets were found that could decrypt) on ${ELISE_ROOT_DIR}/src/elise.sh for ${ELISE_ROOT_DIR}/src/elise.sh" ] || \
           [ "$attempt" == "ERROR! The vault password file ${ELISE_ROOT_DIR}/.vault.txt was not found" ]; then
            exit 1

        fi

    fi
}
