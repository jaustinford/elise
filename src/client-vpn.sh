####################################################
# eslabs_vpn
####################################################

eslabs_vpn_generate_credentials () {
    print_message stdout 'generate vpn credentials' '/tmp/eslabs_ap.credentials'
    cat << EOF > /tmp/eslabs_ap.credentials
${LAB_VPN_USERNAME}
${LAB_VPN_PASSWORD}
EOF
}

eslabs_vpn_generate_config () {
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

eslabs_vpn_connect () {
    eslabs_vpn_generate_credentials
    eslabs_vpn_generate_config

    print_message stdout 'connecting vpn' '/tmp/eslabs_ap.log'
    openvpn \
        --config '/tmp/eslabs_ap.ovpn' \
        --auth-user-pass '/tmp/eslabs_ap.credentials' &> /tmp/eslabs_ap.log &
}

eslabs_vpn_kill () {
    print_message stdout 'kill vpn connection'
    kill -9 $(pidof openvpn)
}

####################################################
# eslabs_squid
####################################################

eslabs_squid_start () {
    cat << EOF > /tmp/squid.conf
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 443
acl CONNECT method CONNECT
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager
http_access allow all
http_port 3128
EOF

    print_message stdout 'starting squid server'
    squid -f /tmp/squid.conf
}

eslabs_squid_kill () {
    print_message stdout 'kill squid server'
    kill -9 $(pidof squid)
}
