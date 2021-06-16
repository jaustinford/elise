####################################################
# deluge_api
####################################################

deluge_api_execute () {
    json_data="$1"

    if [ "$(echo "$json_data" | jq -r '.method')" == 'auth.login' ]; then
        auth_mode='--cookie-jar'

    else
        auth_mode='--cookie'

    fi

    curl -s -X POST "$auth_mode" /tmp/deluge.cookie "https://${LAB_FQDN}/deluge/json" \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --data "$json_data" | jq '.'
}

deluge_api_authenticate () {
    deluge_api_execute "
        {
            \"id\": 1,
            \"method\": \"auth.login\",
            \"params\": [\"${KHARON_DELUGE_PASSWORD}\"]
        }
    "
}

deluge_api_version () {
    deluge_api_execute "
        {
            \"id\": 2,
            \"method\": \"webapi.get_api_version\",
            \"params\": []
        }
    "
}

deluge_api_get_torrents () {
    deluge_api_execute "
        {
            \"id\": 3,
            \"method\": \"webapi.get_torrents\",
            \"params\": []
        }
    "
}

deluge_api_get_torrent_info () {
    torrent_id="$1"

    deluge_api_execute "
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
    "
}

deluge_api_get_torrent_progress () {
    torrent_id="$1"

    deluge_api_execute "
        {
            \"id\": 5,
            \"method\": \"web.get_torrent_status\",
            \"params\": [
                \"$torrent_id\", [
                    \"name\",
                    \"progress\"
                ]
            ]
        }
    "
}

deluge_api_add_torrent () {
    magnet_link="$1"

    deluge_api_execute "
        {
            \"id\": 6,
            \"method\": \"webapi.add_torrent\",
            \"params\": [\"$magnet_link\"]
        }
    "
}

deluge_api_remove_torrent () {
    torrent_id="$1"

    deluge_api_execute "
        {
            \"id\": 7,
            \"method\": \"webapi.remove_torrent\",
            \"params\": [\"$torrent_id\"]
        }
    "
}

deluge_api_display () {
    result=""
    for item in $(deluge_api_get_torrents | jq -r '.result.torrents[].hash'); do
        result+=$(deluge_api_get_torrent_info "$item")

    done

    echo "$result" | jq -s '.'
}
