####################################################
# deluge_api
####################################################

deluge_api_execute () {
    json_data="$1"

    if [ "$(echo "$json_data" | jq -r '.method')" == 'auth.login' ]; then
        curl -s -X POST --cookie-jar /tmp/deluge.cookie "https://${LAB_FQDN}/deluge/json" \
            --header 'Accept: application/json' \
            --header 'Content-Type: application/json' \
            --data "$json_data" &> /dev/null

    else
        curl -s -X POST --cookie /tmp/deluge.cookie "https://${LAB_FQDN}/deluge/json" \
            --header 'Accept: application/json' \
            --header 'Content-Type: application/json' \
            --data "$json_data" | jq '.'

    fi
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
    deluge_api_authenticate
    deluge_api_execute "
        {
            \"id\": 2,
            \"method\": \"webapi.get_api_version\",
            \"params\": []
        }
    "
}

deluge_api_get_torrents () {
    deluge_api_authenticate
    deluge_api_execute "
        {
            \"id\": 3,
            \"method\": \"webapi.get_torrents\",
            \"params\": []
        }
    "
}

deluge_api_info () {
    deluge_api_authenticate

    for torrent_id in $(deluge_api_get_torrents | jq -r '.result.torrents[].hash'); do
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
    done | jq -s '.'
}

deluge_api_progress () {
    deluge_api_authenticate

    for torrent_id in $(deluge_api_get_torrents | jq -r '.result.torrents[].hash'); do
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
    done | jq '.result.name, .result.progress'
}

deluge_api_add_torrent () {
    magnet_link="$1"

    deluge_api_authenticate
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

    deluge_api_authenticate
    deluge_api_execute "
        {
            \"id\": 7,
            \"method\": \"webapi.remove_torrent\",
            \"params\": [\"$torrent_id\"]
        }
    "
}

deluge_api_remove_completed () {
    deluge_api_authenticate

    for torrent_id in $(deluge_api_get_torrents | jq -r '.result.torrents[].hash'); do
        if [ "$(deluge_api_info | jq ".[] | select ( .result.hash == \"$torrent_id\" ) | .result.progress")" == 100 ]; then
            deluge_api_remove_torrent "$torrent_id"

        fi

    done | jq -s '.'
}
