####################################################
# tpb
####################################################

tpb_check_proxy () {
    if [ "${TPB_PROXY_ENABLED}" == 'yes' ]; then
        print_message stdout 'tpb - proxy enabled' "${TPB_PROXY_ENABLED} - ${TPB_PROXY_SERVER}"
        curl_cmd="curl -s -X GET -x ${TPB_PROXY_SERVER}"

    elif [ "${TPB_PROXY_ENABLED}" == 'no' ]; then
        print_message stdout 'tpb - proxy enabled' "${TPB_PROXY_ENABLED}"
        curl_cmd='curl -s -X GET'

    fi
}

tpb_grab_sort_ids () {
    sort_value="$1"

    SORT_ENCODED='bmFtZToxIHVwbG9hZGVkOjMgc2l6ZTo1IG1vc3Rfc2VlZGVyczo3IGxlYXN0X3NlZWRlcnM6OCBtb3N0X2xlZWNoZXJzOjkgbGVhc3RfbGVlY2hlcnM6MTAgdXBsb2FkZWRfYnk6MTEgdHlwZToxMwo='
    SORT_TYPES="$(echo ${SORT_ENCODED} | base64 -d)"

    for item in ${SORT_TYPES[@]}; do
        key=$(echo "$item" | cut -d':' -f1)
        value=$(echo "$item" | cut -d':' -f2)
        if [ "$key" == "$sort_value" ]; then
            echo "$value"

        fi

    done
}

tpb_grab_media_ids () {
    media_value="$1"

    MEDIA_ENCODED='YXVkaW86MTAwIG11c2ljOjEwMSBhdWRpb19ib29rOjEwMiBzb3VuZF9jbGlwczoxMDMgZmxhYzoxMDQgYXVkaW9fb3RoZXI6MTA1IHZpZGVvOjIwMCBtb3ZpZXM6MjAxIG1vdmllc19kdmRyOjIwMiBtdXNpY192aWRlb3M6MjAzIG1vdmllX2NsaXBzOjIwNCB0dl9zaG93czoyMDUgdmlkZW9faGFuZGhlbGQ6MjA2IGhkX21vdmllczoyMDcgaGRfdHZfc2hvd3M6MjA4IDNkOjIwOSB2aWRlb19vdGhlcjoyMTAgYXBwbGljYXRpb25zOjMwMCB3aW5kb3dzOjMwMSBhcHBsaWNhdGlvbnNfbWFjOjMwMiB1bml4OjMwMyBhcHBsaWNhdGlvbnNfaGFuZGhlbGQ6MzA0IGFwcGxpY2F0aW9uc19pb3M6MzA1IGFwcGxpY2F0aW9uc19hbmRyb2lkOjMwNiBhcHBsaWNhdGlvbnNfb3RoZXI6MzA3IGdhbWVzOjQwMCBwYzo0MDEgZ2FtZXNfbWFjOjQwMiBwc3g6NDAzIHhib3gzNjA6NDA0IHdpaTo0MDUgZ2FtZXNfaGFuZGhlbGQ6NDA2IGdhbWVzX2lvczo0MDcgZ2FtZXNfYW5kcm9pZDo0MDggZ2FtZXNfb3RoZXI6NDA5IHBvcm46NTAwIHBvcm5fbW92aWVzOjUwMSBwb3JuX21vdmllc19kdmRyOjUwMiBwb3JuX3BpY3R1cmVzOjUwMyBwb3JuX2dhbWVzOjUwNCBwb3JuX2hkX21vdmllczo1MDUgcG9ybl9tb3ZpZV9jbGlwczo1MDYgcG9ybl9vdGhlcjo1MDcgb3RoZXI6NjAwIGUtYm9va3M6NjAxIGNvbWljczo2MDIgcGljdHVyZXM6NjAzIGNvdmVyczo2MDQgcGh5c2libGVzOjYwNSBvdGhlcl9vdGhlcjo2MDYK'
    MEDIA_TYPES="$(echo ${MEDIA_ENCODED} | base64 -d)"

    for item in ${MEDIA_TYPES[@]}; do
        key=$(echo "$item" | cut -d':' -f1)
        value=$(echo "$item" | cut -d':' -f2)
        if [ "$key" == "$media_value" ]; then
            echo "$value"

        fi

    done
}

tpb_parse_xml () {
    limit="$1"
    xml_result="$2"

    magnets=$(echo "$xml_result" | egrep -o 'magnet:\?xt=.*announce')
    magnets=$(echo "$magnets" | head -$limit)

    print_message stdout 'tpb - results limited' "$limit"
    iter=1
    for line in $magnets; do
        title=$(echo "$line" | cut -d'&' -f2 | cut -d'=' -f2)
        echo -e "
${SHELL_STDOUT_CODE} $iter ${ECHO_RESET}|${SHELL_HOST_PROMPT_CODE} $(url_encode_string url-to-text "$title") ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE}$line${ECHO_RESET}
        "
        iter=$(expr 1 + "$iter")

    done
}

tpb_search () {
    sort_value="$1"
    media_value="$2"
    query="$3"

    url_query=$(url_encode_string text-to-url "$query")
    url_sort=$(tpb_grab_sort_ids "$sort_value")
    url_media=$(tpb_grab_media_ids "$media_value")
    print_message stdout 'tpb - search' "sorted by  : $sort_value"
    print_message stdout 'tpb - search' "media type : $media_value"
    print_message stdout 'tpb - search' "search url : https://${TPB_URL}/search/$url_query/1/$url_sort/$url_media"
    tpb_check_proxy
    tpb_parse_xml ${TPB_RESULTS_LIMIT} "$($curl_cmd "https://${TPB_URL}/search/$url_query/1/$url_sort/$url_media")"
}

tpb_top () {
    media_value="$1"

    url_media=$(tpb_grab_media_ids "$media_value")
    print_message stdout 'tpb - top' "https://${TPB_URL}/top/$url_media"
    tpb_check_proxy
    tpb_parse_xml ${TPB_RESULTS_LIMIT} "$($curl_cmd "https://${TPB_URL}/top/$url_media")"
}

tpb_recent () {
    print_message stdout 'tpb - recent' "https://${TPB_URL}/recent"
    tpb_check_proxy
    tpb_parse_xml ${TPB_RESULTS_LIMIT} "$($curl_cmd "https://${TPB_URL}/recent")"
}
