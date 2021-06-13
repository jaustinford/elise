####################################################
# filebrowser_api
####################################################

filebrowser_api_generate_token () {
    curl -X POST "https://${LAB_FQDN}/tvault/api/login" \
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
    curl -X GET "https://${LAB_FQDN}/tvault/api/resources$src_fqpath" \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --header "X-Auth: $(filebrowser_api_generate_token)" | jq -r '.content' > "$dest_fqpath/$src_file"
}

filebrowser_api_copy_file () {
    src_fqpath="$1"
    dest_fqpath="$2"

    src_fqpath=$(echo "$src_fqpath" | sed -E 's/^\///g')
    url_src=$(url_encode_string "$src_fqpath")
    url_src=$(echo "$url_src" | sed 's/%2F/\//g')
    url_dest=$(url_encode_string "$dest_fqpath")

    print_message stdout 'copying tvault file' "https://${LAB_FQDN}/tvault/files$dest_fqpath"
    curl -X PATCH "https://${LAB_FQDN}/tvault/api/resources/$url_src?action=copy&destination=$url_dest" \
        --header "X-Auth: $(filebrowser_api_generate_token)"
}

filebrowser_api_delete_file () {
    file_fqpath="$1"

    file_fqpath=$(echo "$file_fqpath" | sed -E 's/^\///g')
    url_file=$(url_encode_string "$file_fqpath")
    url_file=$(echo "$url_file" | sed 's/%2F/\//g')

    if [ ! -z "$(echo $url_file | egrep '%2E[0-9a-z]{,}$')" ]; then
        print_message stdout 'deleting tvault file' "/$file_fqpath"
        curl -X DELETE "https://${LAB_FQDN}/tvault/api/resources/$url_file" \
            --header "X-Auth: $(filebrowser_api_generate_token)"

    fi
}
