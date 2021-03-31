####################################################
# youtube-dl wrapper
####################################################

youtube_video_name_from_url () {
    download_url="$1"

    curl -L "$download_url" -so - \
        | grep -iPo '(?<=<title>)(.*)(?=</title>)' \
        | sed -E 's/ - YouTube$//g'
}

youtube_download_from_url () {
    type="$1"
    download_url="$2"

    print_message stdout "downloading $type" "${ELISE_ROOT_DIR}/dropoff/$(youtube_video_name_from_url $download_url)"
    if [ "$type" == 'audio' ]; then
        youtube-dl \
            --prefer-ffmpeg \
            --extract-audio \
            --audio-format mp3 \
            --audio-quality 320K \
            --output "${ELISE_ROOT_DIR}/dropoff/$(youtube_video_name_from_url $download_url).mp31" \
            "$download_url" 1> /dev/null

    elif [ "$type" == 'video' ]; then
        youtube-dl \
            --output "${ELISE_ROOT_DIR}/dropoff/$(youtube_video_name_from_url $download_url)" \
            "$download_url" 1> /dev/null

    fi
}
