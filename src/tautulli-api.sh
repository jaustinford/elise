####################################################
# tautulli_api
####################################################

tautulli_api_execute () {
    cmd="$1"

    curl -X GET "https://${LAB_FQDN}/tautulli/api/v2?apikey=${TAUTULLI_API_KEY}&cmd=$cmd" \
        --header 'Accept: application/json', \
        --header 'Content-Type: application/json' 2> /dev/null
}

tautulli_api_get_activity () {
    activity=$(tautulli_api_execute get_activity)
    session_key=$(echo "$activity" | jq -r '.response.data.sessions[] | .session_key')

    print_message stdout 'displaying tautulli activity' "https://${LAB_FQDN}/tvault"
    stream_count=$(echo "$activity" | jq -r ".response.data.stream_count")
    echo -e "\n active sessions     :  $stream_count"

    for item in $session_key; do
        echo -e "
${SHELL_STDOUT_CODE} full_title         ${ECHO_RESET} : ${SHELL_HOST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\") | .full_title") ${ECHO_RESET}
${SHELL_STDOUT_CODE} library_name       ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\") | .library_name") ${ECHO_RESET}
${SHELL_STDOUT_CODE} user               ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\") | .user") ${ECHO_RESET}
${SHELL_STDOUT_CODE} state              ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\") | .state") ${ECHO_RESET}
${SHELL_STDOUT_CODE} ip_address_public  ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\") | .ip_address_public") ${ECHO_RESET}
${SHELL_STDOUT_CODE} location           ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\") | .location") ${ECHO_RESET}
${SHELL_STDOUT_CODE} progress_percent   ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\") | .progress_percent") ${ECHO_RESET}
${SHELL_STDOUT_CODE} transcode_progress ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\") | .transcode_progress") ${ECHO_RESET}
${SHELL_STDOUT_CODE} quality_profile    ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\") | .quality_profile") ${ECHO_RESET}
${SHELL_STDOUT_CODE} device             ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\") | .device") ${ECHO_RESET}
${SHELL_STDOUT_CODE} device             ${ECHO_RESET} : ${SHELL_HIST_PROMPT_CODE} $(echo "$activity" | jq -r ".response.data.sessions[] | select ( .session_key == \"$item\") | .summary") ${ECHO_RESET}
"
    done
}
