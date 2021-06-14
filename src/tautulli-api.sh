####################################################
# tautulli_api
####################################################

tautulli_api_execute () {
    cmd="$1"
    add_params="$2"

    curl -X GET "https://${LAB_FQDN}/tautulli/api/v2?apikey=${TAUTULLI_API_KEY}&cmd=$cmd$add_params" \
        --header 'Accept: application/json', \
        --header 'Content-Type: application/json' 2> /dev/null
}

tautulli_api_geoip_lookup () {
    ip_address="$1"
    geoip_key="$2"

    if [ ! -z "$geoip_key" ]; then
        tautulli_api_execute get_geoip_lookup "&ip_address=$ip_address" | jq -r ".response.data.$geoip_key"

    else
        tautulli_api_execute get_geoip_lookup "&ip_address=$ip_address" | jq '.'

    fi
}

tautulli_api_get_activity () {
    activity=$(tautulli_api_execute get_activity)
    session_key=$(echo "$activity" | jq -r '.response.data.sessions[] | .session_key')

    print_message stdout 'displaying tautulli activity' "https://${LAB_FQDN}/tvault"
    stream_count=$(echo "$activity" | jq -r ".response.data.stream_count")
    echo -e "\n active sessions     :  $stream_count"

    for item in $session_key; do
        geoip=$(tautulli_api_geoip_lookup $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .ip_address_public"))

        echo -e "
${SHELL_STDOUT_CODE} full_title         ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .full_title") ${ECHO_RESET}
${SHELL_STDOUT_CODE} library_name       ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .library_name") ${ECHO_RESET}
${SHELL_STDOUT_CODE} user               ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .user") ${ECHO_RESET}
${SHELL_STDOUT_CODE} state              ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .state") ${ECHO_RESET}
${SHELL_STDOUT_CODE} ip_address_public  ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .ip_address_public") ${ECHO_RESET}
${SHELL_STDOUT_CODE} code               ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.code") ${ECHO_RESET}
${SHELL_STDOUT_CODE} country            ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.country") ${ECHO_RESET}
${SHELL_STDOUT_CODE} region             ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.region") ${ECHO_RESET}
${SHELL_STDOUT_CODE} city               ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.city") ${ECHO_RESET}
${SHELL_STDOUT_CODE} postal_code        ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.postal_code") ${ECHO_RESET}
${SHELL_STDOUT_CODE} timezone           ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.timezone") ${ECHO_RESET}
${SHELL_STDOUT_CODE} location           ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .location") ${ECHO_RESET}
${SHELL_STDOUT_CODE} progress_percent   ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .progress_percent") ${ECHO_RESET}
${SHELL_STDOUT_CODE} transcode_progress ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .transcode_progress") ${ECHO_RESET}
${SHELL_STDOUT_CODE} quality_profile    ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .quality_profile") ${ECHO_RESET}
${SHELL_STDOUT_CODE} device             ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .device") ${ECHO_RESET}
${SHELL_STDOUT_CODE} device             ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .summary") ${ECHO_RESET}
    "
    done
}

tautulli_api_get_history () {
    history=$(tautulli_api_execute get_history)
    date=$(echo "$history" | jq -r '.response.data.data[] | .date')

    print_message stdout 'displaying tautulli history' "https://${LAB_FQDN}/tvault"
    for item in $date; do
        geoip=$(tautulli_api_geoip_lookup $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .ip_address"))

        echo -e "
${SHELL_STDOUT_CODE} full_title         ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .full_title") ${ECHO_RESET}
${SHELL_STDOUT_CODE} ip_address         ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .ip_address") ${ECHO_RESET}
${SHELL_STDOUT_CODE} code               ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.code") ${ECHO_RESET}
${SHELL_STDOUT_CODE} country            ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.country") ${ECHO_RESET}
${SHELL_STDOUT_CODE} region             ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.region") ${ECHO_RESET}
${SHELL_STDOUT_CODE} city               ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.city") ${ECHO_RESET}
${SHELL_STDOUT_CODE} postal_code        ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.postal_code") ${ECHO_RESET}
${SHELL_STDOUT_CODE} timezone           ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.timezone") ${ECHO_RESET}
${SHELL_STDOUT_CODE} user               ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .user") ${ECHO_RESET}
${SHELL_STDOUT_CODE} date               ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .date") ${ECHO_RESET}
${SHELL_STDOUT_CODE} started            ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .started") ${ECHO_RESET}
${SHELL_STDOUT_CODE} stopped            ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .stopped") ${ECHO_RESET}
${SHELL_STDOUT_CODE} product            ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .product") ${ECHO_RESET}
${SHELL_STDOUT_CODE} percent_complete   ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .percent_complete") ${ECHO_RESET}
"

    done
}
