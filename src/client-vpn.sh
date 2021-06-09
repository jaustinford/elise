####################################################
# vpn
####################################################

vpn_generate_credentials () {
    print_message stdout 'generate vpn credentials' '/tmp/eslabs_ap.credentials'
    cat << EOF > /tmp/eslabs_ap.credentials
${LAB_VPN_USERNAME}
${LAB_VPN_PASSWORD}
EOF
}

vpn_generate_config () {
    token=$(curl -X POST "https://${LAB_FQDN}/tvault/api/login" 2> /dev/null \
        --header 'Accept: */*' \
        --header 'Content-Type: application/json' \
        --data "
            {
                \"username\": \"${FILEBROWSER_USERNAME}\",
                \"password\": \"${FILEBROWSER_PASSWORD}\",
                \"recaptcha\": \"\"
            }
        "
    )

    print_message stdout 'generate ovpn file' '/tmp/eslabs_ap.ovpn'
    curl -X GET "https://${LAB_FQDN}/tvault/api/resources/es-labs/eslabs_ap.ovpn" 2> /dev/null \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --header "X-Auth: $token" | jq -r '.content' > '/tmp/eslabs_ap.ovpn'
}

vpn_connect () {
    vpn_generate_credentials
    vpn_generate_config

    print_message stdout 'connecting vpn' '/tmp/eslabs_ap.log'
    openvpn \
        --config '/tmp/eslabs_ap.ovpn' \
        --auth-user-pass '/tmp/eslabs_ap.credentials' &> /tmp/eslabs_ap.log &
}

vpn_kill () {
    kill -9 $(pidof openvpn)
}
