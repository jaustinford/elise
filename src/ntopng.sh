ntopng_install () {
    if [ -z "$(which ntopng 2> /dev/null)" ]; then
        print_message 'stdout' 'installing repo' "$1"
        wget "http://packages.ntop.org/RaspberryPI/${NTOPNG_REPO}" 1> /dev/null
        dpkg -i apt-ntop_1.0.190416-469_all.deb 1> /dev/null
    
        for pkg in ntopng nrpobe n2n; do
            print_message 'stdout' 'installing package' "$pkg"
            apt install "$pkg" -y 1> /dev/null
    
        done
    
    fi
}

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
