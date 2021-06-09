####################################################
# filebrowser_api
####################################################

filebrowser_api_generate_token () {
    curl -X POST "https://${LAB_FQDN}/tvault/api/login" 2> /dev/null \
        --header 'Accept: */*' \
        --header 'Content-Type: application/json' \
        --data "
            {
                \"username\": \"${FILEBROWSER_USERNAME}\",
                \"password\": \"${FILEBROWSER_PASSWORD}\",
                \"recaptcha\": \"\"
            }
        "
}

filebrowser_api_download_file () {
    src_fqpath="$1"
    dest_fqpath="$2"
    
    src_file=$(echo "$src_fqpath" | egrep -o '[a-zA-Z0-9_-]{,}([.][a-zA-Z0-9_-]{,}){,}$')

    print_message stdout 'downloading tvault file' "$dest_fqpath/$src_file"
    curl -X GET "https://${LAB_FQDN}/tvault/api/resources$src_fqpath" 2> /dev/null \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --header "X-Auth: $(filebrowser_api_generate_token)" | jq -r '.content' > "$dest_fqpath/$src_file"
}
