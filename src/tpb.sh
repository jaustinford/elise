####################################################
# tpb
####################################################

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
    xml_result="$1"

    magnets=$(echo "$xml_result" | egrep '^<a href="magnet:' | cut -d'"' -f2)

    for line in $magnets; do
        title=$(echo "$line" | cut -d'&' -f2 | cut -d'=' -f2)
        echo -e "\
${SHELL_HOST_PROMPT_CODE}$title ${ECHO_RESET}
${SHELL_HIST_PROMPT_CODE}$line ${ECHO_RESET}
        "

    done
}

tpb_search () {
    sort_value="$1"
    media_value="$2"
    query="$3"

    url_query=$(url_encode_string "$query")
    url_sort=$(tpb_grab_sort_ids "$sort_value")
    url_media=$(tpb_grab_media_ids "$media_value")
    tpb_parse_xml $(curl -s -X GET "https://${TPB_URL}/search/$url_query/1/$url_sort/$url_media")
}

tpb_top () {
    media_value="$1"

    url_media=$(tpb_grab_media_ids "$media_value")
    tpb_parse_xml $(curl -s -X GET "https://${TPB_URL}/top/$url_media")
}

tpb_recent () {
    tpb_parse_xml $(curl -s -X GET "https://${TPB_URL}/recent/1")
}
