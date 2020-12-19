#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.env"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"

find_operating_system
if [ "${operating_system}" == "Raspbian GNU/Linux 10 (buster)" ]; then
    while true; do
        temp_c=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
        temp_f=$(echo $temp_c*9/5+32 | bc -l)
        print_message 'stdout' "$(date +%Y.%m.%d-%H:%M:%S) - $(echo $temp_f | egrep -o '[0-9]{1,}[.][0-9]{2}') degrees fahrenheit"
        sleep 4

    done

fi
