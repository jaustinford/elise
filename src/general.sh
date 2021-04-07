####################################################
# colors
####################################################

export_color_codes () {
    ECHO_FORMAT_TEXT='normal'
    BASH_COLORS=(
        '30m|black'
        '31m|red'
        '32m|green'
        '33m|yellow'
        '34m|blue'
        '35m|purple'
        '36m|cyan'
        '37m|lightgray'
        '90m|gray'
        '91m|lightred'
        '92m|lightgreen'
        '93m|lightyellow'
        '94m|lightblue'
        '95m|lightpurple'
        '96m|lightcyan'
        '97m|white'
    )

    ECHO_START_CODE='\e['
    ECHO_RESET="${ECHO_START_CODE}00m"
    export ECHO_RESET

    if [ "${ECHO_FORMAT_TEXT}" == 'normal' ]; then ECHO_FORMAT_CODE='0'
    elif [ "${ECHO_FORMAT_TEXT}" == 'bold' ]; then ECHO_FORMAT_CODE='1'
    elif [ "${ECHO_FORMAT_TEXT}" == 'italics' ]; then ECHO_FORMAT_CODE='3'
    fi

    shell_vars=$(egrep '^SHELL_' "${ELISE_ROOT_DIR}/src/elise.sh")

    for var in $shell_vars; do
        key="$(echo "$var" | cut -d'=' -f1 | sed "s/_COLOR/_CODE/g")"
        value="$(echo "$var" | cut -d'=' -f2 | sed "s/'//g")"
        nested_value="$(echo "$value" | egrep '^"\$')"

        if [ ! -z "$nested_value" ]; then
            original_key="$(echo "$nested_value" | sed -E 's/[${}"]//g')"
            value="$(egrep "^$original_key" "${ELISE_ROOT_DIR}/src/elise.sh" | cut -d'=' -f2 | sed "s/'//g")"

        fi

        for bash_color in ${BASH_COLORS[@]}; do
            color_found=''
            color_code="$(echo "$bash_color" | cut -d'|' -f1)"
            color_name="$(echo "$bash_color" | cut -d'|' -f2)"

            if [ "$value" == "$color_name" ]; then
                export $key="${ECHO_START_CODE}${ECHO_FORMAT_CODE};$color_code"
                color_found='true'
                break

            fi

        done

        if [ -z "$color_found" ]; then
            print_message stderr 'incorrect color value' "$key='$value'"
            break

        fi

    done
}

update_colors () {
    user_color="$1"
    time_color="$2"
    host_color="$3"
    cwd_color="$4"

    if [ "$#" == '4' ]; then
        vars_update SHELL_USER_PROMPT_COLOR "$user_color"
        vars_update SHELL_TIME_PROMPT_COLOR "$time_color"
        vars_update SHELL_CWD_PROMPT_COLOR "$cwd_color"
        vars_update SHELL_HOST_PROMPT_COLOR "$host_color"

    fi
}

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
            echo -e "  ${SHELL_STDOUT_CODE}OUT${ECHO_RESET} [ ${SHELL_TIME_PROMPT_CODE}$(date '+%Y.%m.%d - %H:%M:%S')${ECHO_RESET} ] ${SHELL_HOST_PROMPT_CODE}$message_1${ECHO_RESET} | ${SHELL_CWD_PROMPT_CODE}$message_2${ECHO_RESET}"

        else
            echo -e "  ${SHELL_STDOUT_CODE}OUT${ECHO_RESET} [ ${SHELL_TIME_PROMPT_CODE}$(date '+%Y.%m.%d - %H:%M:%S')${ECHO_RESET} ] ${SHELL_HOST_PROMPT_CODE}$message_1${ECHO_RESET}"

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
        sed -i "s/$old_string/$new_string/g" "$file"

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

countdown_to_cmd () {
    command="$1"
    time="$2"

    if [ ! -z "$time" ] && \
       [ ! -z "$command" ]; then
        print_message stdout "scheduled for $time" "$command"
        while [ "$(date +%H:%M:%S)" != "$time" ]; do
            sleep 1

        done

    fi

    print_message stdout "executing '$command'"
    /bin/bash -c "$command"
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
        print_message stdout "curl $http_response $message" "$http_mode://$domain$web_path"

    else
        print_message stderr "curl $http_response $message" "$http_mode://$domain$web_path"

    fi
}

nmap_scan () {
    host="$1"
    port="$2"

    while true; do
        state="$(nmap -Pn -p "$port" "$host" \
            | egrep "^$port\/(tcp|udp)" \
            | awk '{print $2}')"

        if [ "$state" == 'open' ]; then
            print_message stdout 'nmap reports port is open' "$host:$port"

        else
            print_message stderr "nmap reports port is $state" "$host:$port"

        fi

        sleep 1

    done
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

        if [ "$(head -1 ${ELISE_ROOT_DIR}/src/elise.sh)" != '$ANSIBLE_VAULT;1.1;AES256' ]; then
            . "${ELISE_ROOT_DIR}/src/elise.sh"
            . "${ELISE_ROOT_DIR}/src/general.sh"
            export_color_codes

        fi

        if [ "$attempt" == "ERROR! Decryption failed (no vault secrets were found that could decrypt) on ${ELISE_ROOT_DIR}/src/elise.sh for ${ELISE_ROOT_DIR}/src/elise.sh" ]; then
            print_message stderr 'vault password incorrect' "${ELISE_ROOT_DIR}/.vault.txt"
            exit 1

        elif [ "$attempt" == "ERROR! The vault password file ${ELISE_ROOT_DIR}/.vault.txt was not found" ]; then
            print_message stderr 'vault file not found' "${ELISE_ROOT_DIR}/.vault.txt"
            exit 1

        elif [ "$attempt" == "ERROR! input is not vault encrypted data${ELISE_ROOT_DIR}/src/elise.sh is not a vault encrypted file for ${ELISE_ROOT_DIR}/src/elise.sh" ]; then
            print_message stdout 'vault file already decrypted' "${ELISE_ROOT_DIR}/.vault.txt"

        elif [ -z "$attempt" ]; then
            print_message stdout 'decryption successful' "${ELISE_ROOT_DIR}/.vault.txt"

        fi

    fi
}
