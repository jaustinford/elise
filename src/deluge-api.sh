####################################################
# deluge_api
####################################################

deluge_api_authenticate () {
    print_message stdout 'authenticating deluge' '/tmp/deluge.cookie'
    curl -X POST -c /tmp/deluge.cookie "https://${LAB_FQDN}/deluge/json" \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --data "
            {
                \"id\": 1,
                \"method\": \"auth.login\",
                \"params\": [\"${KHARON_DELUGE_PASSWORD}\"]
            }
        " 2> /dev/null | jq '.'
}

deluge_api_version () {
    deluge_api_authenticate
    print_message stdout 'querying deluge api version'
    curl -X POST -b /tmp/deluge.cookie "https://${LAB_FQDN}/deluge/json" \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --data "
            {
                \"id\": 2,
                \"method\": \"webapi.get_api_version\",
                \"params\": []
            }
        " 2> /dev/null | jq '.'
}


deluge_api_get_torrents () {
    deluge_api_authenticate
    print_message stdout 'display torrents'
    curl -X POST -b /tmp/deluge.cookie "https://${LAB_FQDN}/deluge/json" \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --data "
            {
                \"id\": 3,
                \"method\": \"webapi.get_torrents\",
                \"params\": []
            }
        " 2> /dev/null | jq '.'
}

deluge_api_get_torrent_info () {
    torrent_id="$1"

    deluge_api_authenticate
    print_message stdout 'displaying torrent info' "$torrent_id"
    curl -X POST -b /tmp/deluge.cookie "https://${LAB_FQDN}/deluge/json" \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --data "
            {
                \"id\": 4,
                \"method\": \"web.get_torrent_status\",
                \"params\": [
                    \"$torrent_id\", [
                        \"name\",
                        \"hash\",
                        \"total_size\",
                        \"files\",
                        \"progress\"
                    ]
                ]
            }
        " 2> /dev/null | jq '.'
}

deluge_api_get_torrent_progress () {
    torrent_id="$1"

    deluge_api_authenticate
    print_message stdout 'displaying torrent progress' "$torrent_id"
    curl -X POST -b /tmp/deluge.cookie "https://${LAB_FQDN}/deluge/json" \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --data "
            {
                \"id\": 5,
                \"method\": \"web.get_torrent_status\",
                \"params\": [
                    \"$torrent_id\", [
                        \"progress\"
                    ]
                ]
            }
        " 2> /dev/null | jq '.'
}

deluge_api_add_torrent () {
    magnet_link="$1"

    deluge_api_authenticate
    print_message stdout 'adding torrent' "$magnet_link"
    curl -X POST -b /tmp/deluge.cookie "https://${LAB_FQDN}/deluge/json" \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --data "
            {
                \"id\": 6,
                \"method\": \"webapi.add_torrent\",
                \"params\": [\"$magnet_link\"]
            }
        " 2> /dev/null | jq '.'
}

deluge_api_remove_torrent () {
    torrent_id="$1"

    deluge_api_authenticate
    print_message stdout 'removing torrent' "$torrent_id"
    curl -X POST -b /tmp/deluge.cookie "https://${LAB_FQDN}/deluge/json" \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --data "
            {
                \"id\": 7,
                \"method\": \"webapi.remove_torrent\",
                \"params\": [\"$torrent_id\"]
            }
        " 2> /dev/null | jq '.'
}
