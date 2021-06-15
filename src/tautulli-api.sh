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
    target_fqdn="$1"
    geoip_key="$2"

    if [ -z "$(echo $target_fqdn | egrep '^([0-9]{,}[.]){3}[0-9]{,}$')" ]; then
        ip_address="$(dig +short $target_fqdn)"

    else
        ip_address="$target_fqdn"

    fi

    if [ ! -z "$geoip_key" ]; then
        tautulli_api_execute get_geoip_lookup "&ip_address=$ip_address" | jq -r ".response.data.$geoip_key"

    else
        tautulli_api_execute get_geoip_lookup "&ip_address=$ip_address" | jq '.'

    fi
}

tautulli_api_get_activity () {
    activity=$(tautulli_api_execute get_activity)
    session_key=$(echo "$activity" | jq -r '.response.data.sessions[] | .session_key')

    print_message stdout 'displaying tautulli activity' "https://${LAB_FQDN}/tautulli"
    stream_count=$(echo "$activity" | jq -r ".response.data.stream_count")
    echo -e "\n active sessions        :  $stream_count"

    for item in $session_key; do
        geoip=$(tautulli_api_geoip_lookup $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .ip_address_public"))

        echo -e "
${SHELL_HIST_PROMPT_CODE} full_title            ${ECHO_RESET} : ${SHELL_STDOUT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .full_title") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} parent_title          ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .parent_title") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} library_name          ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .library_name") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} user                  ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .user") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} state                 ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .state") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} ip_address_public     ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .ip_address_public") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} code                  ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.code") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} country               ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.country") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} region                ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.region") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} city                  ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.city") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} postal_code           ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.postal_code") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} timezone              ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.timezone") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} location              ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .location") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} progress_percent      ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .progress_percent") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} transcode_progress    ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .transcode_progress") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} quality_profile       ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .quality_profile") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} video_full_resolution ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .video_full_resolution") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} device                ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .device") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} summary               ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\" ) | .summary") ${ECHO_RESET}
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
${SHELL_HIST_PROMPT_CODE} full_title            ${ECHO_RESET} : ${SHELL_STDOUT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .full_title") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} user                  ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .user") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} ip_address            ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .ip_address") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} code                  ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.code") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} country               ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.country") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} region                ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.region") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} city                  ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.city") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} postal_code           ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.postal_code") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} timezone              ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.timezone") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} date                  ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(date -d @$(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .date")) ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} started               ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(date -d @$(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .started")) ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} stopped               ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(date -d @$(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .stopped")) ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} product               ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .product") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} percent_complete      ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .percent_complete") ${ECHO_RESET}
        "

    done
}

tautulli_api_search () {
    query="$1"

    print_message stdout 'searching plex server' "$query"
    url_search=$(url_encode_string "$query")
    search_result=$(tautulli_api_execute search "&query=$url_search&limit=254")
    print_message stdout 'search results found' "$(echo "$search_result" | jq '.response.data.results_count')"

    echo -e "
${SHELL_STDOUT_CODE}  movies ${ECHO_RESET}

${SHELL_HOST_PROMPT_CODE}$(echo "$search_result" | jq -r '.response.data.results_list.movie[].title') ${ECHO_RESET}

${SHELL_STDOUT_CODE}  shows ${ECHO_RESET}

${SHELL_HOST_PROMPT_CODE}$(echo "$search_result" | jq -r '.response.data.results_list.show[].title') ${ECHO_RESET}

${SHELL_STDOUT_CODE}  seasons ${ECHO_RESET}

${SHELL_HOST_PROMPT_CODE}$(echo "$search_result" | jq -r '.response.data.results_list.season[] | .title, .parent_title') ${ECHO_RESET}

${SHELL_STDOUT_CODE}  episodes ${ECHO_RESET}

${SHELL_HOST_PROMPT_CODE}$(echo "$search_result" | jq -r '.response.data.results_list.episode[] | .title, .grandparent_title') ${ECHO_RESET}
    "
}
