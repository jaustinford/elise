ssh_key () {
    print_message 'stdout' 'configure user ssh key' '/tmp/id_rsa'
    echo "${LAB_USER_AUSTIN_SSH_KEY}" | base64 -d > /tmp/id_rsa
    chmod 600 /tmp/id_rsa
}

ssh_client_config () {
    print_message 'stdout' 'generate client ssh config' '/tmp/ssh_config'
    cat <<EOF > /tmp/ssh_config
Host kube0* dns
    User ubuntu

Host watcher0* eva
    User austin

Host netmon
    User pi

Host tvault
    User sshd

Host labs.elysianskies.com
    User ubuntu
    Port 6945
EOF
    chmod 600 /tmp/ssh_config
}

add_local_dns_search () {
    print_message 'stdout' 'generate local dns search' "/etc/resolv.conf"
    if [ -z "$(grep $1 /etc/resolv.conf)" ]; then
        echo "search $1" >> /etc/resolv.conf

    fi
}

check_cluster_from_wan_connectivity () {
    if [ $(nmap -Pn -p $1 ${LAB_FQDN} | egrep "^$1\/(udp|tcp)" | awk '{print $2}') == 'open' ]; then
        print_message 'stdout' 'lab wan connection confirmed' "${LAB_FQDN}:$1"

    else
        print_message 'stderr' 'lab wan connection refused' "${LAB_FQDN}:$1"

    fi
}

greeting () {
    chour=$(date | awk '{print $4}' | cut -d':' -f1)

    if [ "$chour" -ge 0 ] && [ "$chour" -lt 5 ]; then message="it's way past your bed time"
    elif [ "$chour" -ge 5 ] && [ "$chour" -lt 7 ]; then message="the early bird gets the worm"
    elif [ "$chour" -ge 7 ] && [ "$chour" -lt 12 ]; then message="good morning"
    elif [ "$chour" -ge 12 ] && [ "$chour" -lt 17 ]; then message="good afternoon"
    elif [ "$chour" -ge 17 ] && [ "$chour" -lt 22 ]; then message="good evening"
    elif [ "$chour" -ge 22 ] && [ "$chour" -lt 24 ]; then message="it's getting late"
    fi

    echo -e "          $message$SHELL_USER_PROMPT_CODE $1 $ECHO_RESET\n"
}

curl_http () {
    http_response=$(curl -i $1://$3$2 2> /dev/null | egrep ^HTTP\/ | awk '{print $2}')
    if [ "$http_response" == '200' ]; then
        print_message 'stdout' "$1 curl returned $http_response" "$1://$3$2"

    else
        print_message 'stderr' "$1 curl returned $http_response" "$1://$3$2"

    fi
}