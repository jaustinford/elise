####################################################
# plex_api
####################################################

plex_api_grab_library_id () {
    plex_library="$1"

    curl -s -X GET "https://${LAB_FQDN}:32400/library/sections?X-Plex-Token=${PLEX_TOKEN}" \
        | egrep  "title=\"$plex_library\"" \
        | egrep -o '\/library\/sections\/[0-9]{,}\/composite' \
        | cut -d'/' -f4
}

plex_api_refresh_library () {
    plex_library="$1"

    id=$(plex_api_grab_library_id $plex_library)

    print_message stdout 'refreshing plex library' "$id:$plex_library"
    curl -s -X GET "https://${LAB_FQDN}:32400/library/sections/$id/refresh?X-Plex-Token=${PLEX_TOKEN}"
}
