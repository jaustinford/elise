#!/usr/bin/env bash

set -e

. "${SHELL_ROOT_DIR}/src/general.sh"

operating_system="$(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | sed 's/"//g')"

if [ "${operating_system}" == "Raspbian GNU/Linux 10 (buster)" ]; then
    while true; do
        temp_c=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
        temp_f=$(echo $temp_c*9/5+32 | bc -l)
        print_message "$(date +%Y.%m.%d-%H:%M:%S) - $(echo $temp_f | egrep -o '[0-9]{1,}[.][0-9]{2}') degrees fahrenheit"
        sleep 4

    done

fi
