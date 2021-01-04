print_rpi_temp () {
    if [ "$1" == "Raspbian GNU/Linux 10 (buster)" ]; then
        while true; do
            temp_c=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
            temp_f=$(echo $temp_c*9/5+32 | bc -l)
            print_message 'stdout' "$(date +%Y.%m.%d-%H:%M:%S) - $(echo $temp_f | egrep -o '[0-9]{1,}[.][0-9]{2}') degrees fahrenheit"
            sleep 4

        done

    fi
}

install_v4l2rtspserver () {
    if [ "$1" == "Raspbian GNU/Linux 10 (buster)" ]; then
        if [ -z $(which v4l2rtspserver) ]; then
            print_message 'stdout' 'installing v4l2rtspserver'
            apt update -y
            apt install -y git cmake
            git clone https://github.com/mpromonet/v4l2rtspserver.git
            cd v4l2rtspserver
            cmake .
            make
            make install
            apt-get install -y \
                v4l-utils \
                uvcdynctrl

        fi

    fi
}

install_cron () {
    if [ "$1" == "Raspbian GNU/Linux 10 (buster)" ]; then
        cron_service='cron'
        if [ -z "$(dpkg --get-selections | grep cron)" ]; then
            print_message 'stdout' 'installing cron' "$(hostname)"
            apt-get install -y cron

        fi

    elif [ "$1" == 'CentOS Linux 8' ]; then
        cron_service='crond'
        if [ -z "$(rpm -qa | grep cronie)" ]; then
            print_message 'stdout' 'installing cronie' "$(hostname)"
            yum install -y cronie

        fi

    fi

    print_message 'stdout' 'configuring cron systemd' "$(hostname)"
    systemctl enable "$cron_service" 1> /dev/null
    systemctl start "$cron_service" 1> /dev/null
}
