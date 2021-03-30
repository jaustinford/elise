####################################################
# youtube-dl wrapper
####################################################

youtube_video_name_from_url () {
    curl -L $1 -so - \
        | grep -iPo '(?<=<title>)(.*)(?=</title>)' \
        | sed -E 's/ - YouTube$//g'
}

youtube_download_file () {
    print_message 'stdout' "downloading $1" "${ELISE_ROOT_DIR}/dropoff/$(youtube_video_name_from_url $2)"
    if [ "$1" == "audio" ]; then
        youtube-dl \
            --prefer-ffmpeg \
            --extract-audio \
            --audio-format mp3 \
            --audio-quality "320K" \
            --output "${ELISE_ROOT_DIR}/dropoff/$(youtube_video_name_from_url $2).mp31" \
            "$2" 1> /dev/null

    elif [ "$1" == "video" ]; then
        youtube-dl \
            --output "${ELISE_ROOT_DIR}/dropoff/$(youtube_video_name_from_url $2)" \
            "$2" 1> /dev/null

    fi
}
