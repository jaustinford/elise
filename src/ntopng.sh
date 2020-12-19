ntopng_webroot () {
    if [ -z "$(egrep ^--http-prefix /etc/ntopng/ntopng.conf 2> /dev/null)" ]; then
        print_message 'stdout' 'configuring webroot' '/ntopng'
        echo '--http-prefix="/ntopng"' >> /etc/ntopng/ntopng.conf

    fi
}

ntopng_service () {
    print_message 'stdout' 'configure service' 'ntopng'
    systemctl enable ntopng
    systemctl start ntopng
}
