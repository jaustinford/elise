grab_download_name () {
    curl -L $1 -so - \
        | grep -iPo '(?<=<title>)(.*)(?=</title>)' \
        | sed -E 's/ - YouTube$//g'
}

ensure_dropoff () {
    if [ ! -d "$1" ]; then
        print_message 'stdout' 'creating dropoff directory' "$1"

    fi
}

download_file () {
    print_message 'stdout' "downloading $1" "$2/$3"
    if [ "$1" == "audio" ]; then
        youtube-dl \
            --prefer-ffmpeg \
            --extract-audio \
            --audio-format mp3 \
            --audio-quality "320K" \
            --output "$2/$3.mp31" \
            "$4" 1> /dev/null

    elif [ "$1" == "video" ]; then
        youtube-dl \
            --output "$2/$3" \
            "$4" 1> /dev/null

    fi
}
