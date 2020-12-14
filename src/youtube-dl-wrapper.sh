grab_download_name() {
    curl -L $1 -so - \
        | grep -iPo '(?<=<title>)(.*)(?=</title>)' \
        | sed -E 's/ - YouTube$//g'
}

download_file() {
    if [ "$1" == "audio" ]; then
        youtube-dl \
            --prefer-ffmpeg \
            --extract-audio \
            --audio-format mp3 \
            --audio-quality "$5K" \
            --output "$2/$3.mp31" \
            "$4"

    elif [ "$1" == "video" ]; then
        youtube-dl \
            --output "$2/$3" \
            "$4"

    fi
}
