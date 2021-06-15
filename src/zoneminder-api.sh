####################################################
# zoneminder_api
####################################################

zoneminder_api_authenticate () {
    curl -X POST "https://${LAB_FQDN}/zm/api/host/login.json" \
        --header 'Accept: application/json' \
        --data "user=${ZONEMINDER_USERNAME}&pass=${ZONEMINDER_PASSWORD}" 2> /dev/null | jq -r '.access_token'
}

zoneminder_api_version () {
    curl -X GET "https://${LAB_FQDN}/zm/api/host/getVersion.json?token=$(zoneminder_api_authenticate)" \
        --header 'Accept: application/json' 2> /dev/null | jq '.'
}

zoneminder_api_get_monitors () {
    curl -X GET "https://${LAB_FQDN}/zm/api/monitors.json?token=$(zoneminder_api_authenticate)" \
        --header 'Accept: application/json' 2> /dev/null | jq '.'
}

zoneminder_api_change_function () {
    function="$1"
    enabled="$2"
    monitor="$3"

    curl -X POST "https://${LAB_FQDN}/zm/api/monitors/$monitor.json?token=$(zoneminder_api_authenticate)" \
        --header 'Accept: application/json' \
        --data "Monitor[Function]=$function&Monitor[Enabled]=$enabled" 2> /dev/null | jq '.'
}

zoneminder_api_change_function_all_monitors () {
    function="$1"
    enabled="$2"

    for monitor in $(zoneminder_api_get_monitors | jq -r '.monitors[].Monitor.Id'); do
        zoneminder_api_change_function "$function" "$enabled" "$monitor"

    done
}
