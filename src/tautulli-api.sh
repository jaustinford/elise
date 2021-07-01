####################################################
# tautulli_api
####################################################

tautulli_api_execute () {
    cmd="$1"
    add_params="$2"

    curl -s -X GET "https://${LAB_FQDN}/tautulli/api/v2?apikey=${TAUTULLI_API_KEY}&cmd=$cmd$add_params" \
        --header 'Accept: application/json', \
        --header 'Content-Type: application/json'
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
    rating_key=$(echo "$activity" | jq -r '.response.data.sessions[] | .rating_key')
    print_message stdout 'displaying tautulli activity' "https://${LAB_FQDN}/tautulli"
    stream_count=$(echo "$activity" | jq -r '.response.data.stream_count')
    echo -e "\n active sessions          :  $stream_count"

    for item in $rating_key; do
        geoip=$(tautulli_api_geoip_lookup $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .ip_address_public"))

        echo -e "
${SHELL_HIST_PROMPT_CODE} full_title              ${ECHO_RESET} : ${SHELL_STDOUT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .full_title") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} rating_key              ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $rating_key ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} originally_available_at ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .originally_available_at") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} parent_title            ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .parent_title") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} media_index             ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .media_index") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} library_name            ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .library_name") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} user                    ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .user") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} state                   ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .state") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} ip_address_public       ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .ip_address_public") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} code                    ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.code") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} country                 ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.country") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} region                  ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.region") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} city                    ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.city") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} postal_code             ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.postal_code") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} timezone                ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.timezone") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} location                ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .location") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} progress_percent        ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .progress_percent") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} transcode_progress      ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .transcode_progress") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} quality_profile         ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .quality_profile") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} video_full_resolution   ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .video_full_resolution") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} device                  ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .device") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} summary                 ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .rating_key == \"$item\" ) | .summary") ${ECHO_RESET}
        "

    done
}

tautulli_api_get_history () {
    history=$(tautulli_api_execute get_history)
    date=$(echo "$history" | jq -r '.response.data.data[] | .date')

    print_message stdout 'displaying tautulli history' "https://${LAB_FQDN}/tautulli"
    for item in $date; do
        geoip=$(tautulli_api_geoip_lookup $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .ip_address"))

        echo -e "
${SHELL_HIST_PROMPT_CODE} full_title              ${ECHO_RESET} : ${SHELL_STDOUT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .full_title") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} rating_key              ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .rating_key") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} originally_available_at ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .originally_available_at") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} user                    ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .user") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} ip_address              ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .ip_address") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} code                    ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.code") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} country                 ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.country") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} region                  ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.region") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} city                    ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.city") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} postal_code             ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.postal_code") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} timezone                ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$geoip" | jq -r ".response.data.timezone") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} date                    ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(date -d @$(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .date")) ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} started                 ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(date -d @$(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .started")) ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} stopped                 ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(date -d @$(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .stopped")) ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} product                 ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .product") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE} percent_complete        ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$history" | jq -r ".response.data.data[] | select ( .date == $item ) | .percent_complete") ${ECHO_RESET}
        "

    done
}

tautulli_api_search () {
    query="$1"

    print_message stdout 'searching plex server' "$query"
    url_search=$(url_encode_string text-to-url "$query")
    search_result=$(tautulli_api_execute search "&query=$url_search&limit=254")
    print_message stdout 'search results found' "$(echo "$search_result" | jq '.response.data.results_count')"

    if [ ! -z "$(echo "$search_result" | jq -r '.response.data.results_list.movie[].rating_key')" ]; then
        echo -e "${SHELL_STDOUT_CODE}\n movies ${ECHO_RESET}(${SHELL_HIST_PROMPT_CODE} rating_key${ECHO_RESET},${SHELL_HIST_PROMPT_CODE} title${ECHO_RESET} )"
        echo "$search_result" | jq -r '.response.data.results_list.movie[] | .rating_key, .title'

    fi

    if [ ! -z "$(echo "$search_result" | jq -r '.response.data.results_list.show[].rating_key')" ]; then
        echo -e "${SHELL_STDOUT_CODE}\n shows ${ECHO_RESET}(${SHELL_HIST_PROMPT_CODE} rating_key${ECHO_RESET},${SHELL_HIST_PROMPT_CODE} title${ECHO_RESET} )"
        echo "$search_result" | jq -r '.response.data.results_list.show[] | .rating_key, .title'

    fi

    if [ ! -z "$(echo "$search_result" | jq -r '.response.data.results_list.season[].rating_key')" ]; then
        echo -e "${SHELL_STDOUT_CODE}\n seasons ${ECHO_RESET}(${SHELL_HIST_PROMPT_CODE} rating_key${ECHO_RESET},${SHELL_HIST_PROMPT_CODE} title${ECHO_RESET},${SHELL_HIST_PROMPT_CODE} parent_title${ECHO_RESET} )"
        echo "$search_result" | jq -r '.response.data.results_list.season[] | .rating_key, .title, .parent_title'

    fi

    if [ ! -z "$(echo "$search_result" | jq -r '.response.data.results_list.episode[].rating_key')" ]; then
        echo -e "${SHELL_STDOUT_CODE}\n episodes ${ECHO_RESET}(${SHELL_HIST_PROMPT_CODE} rating_key${ECHO_RESET},${SHELL_HIST_PROMPT_CODE} title${ECHO_RESET},${SHELL_HIST_PROMPT_CODE} grandparent_title${ECHO_RESET} )"
        echo "$search_result" | jq -r '.response.data.results_list.episode[] | .rating_key, .title, .grandparent_title'

    fi
}

tautulli_api_describe () {
    rating_key="$1"
    search_key="$2"

    timestamp_keys=(
        'added_at'
        'updated_at'
        'last_viewed_at'
    )

    if [ -z "$search_key" ]; then
        tautulli_api_execute get_metadata "&rating_key=$rating_key" | jq '.response.data'

    else
        timestamp='no'
        for timestamp_key in ${timestamp_keys[@]}; do
            if [ "$search_key" == "$timestamp_key" ]; then
                timestamp='yes'
                break

            fi

        done

        if [ "$timestamp" == 'yes' ];then
            date -d @$(tautulli_api_execute get_metadata "&rating_key=$rating_key" | jq -r ".response.data.$search_key")

        else
            tautulli_api_execute get_metadata "&rating_key=$rating_key" | jq ".response.data.$search_key"

        fi

    fi
}
