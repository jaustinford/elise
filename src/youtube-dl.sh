####################################################
# youtube-dl wrapper
####################################################

youtube_video_name_from_url () {
    download_url="$1"

    curl -L "$download_url" -so - \
        | grep -iPo '(?<=<title>)(.*)(?=</title>)' \
        | sed -E 's/ - YouTube$//g' \
        | sed -E "s/&#39;/\'/g" \
        | sed -E 's/&quot;/\"/g' \
        | sed -E 's/&amp;/and/g'
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

youtube_download_from_group () {
    # this is inherently limited to the first 30 videos
    # of a group since that's all that gets returned to
    # the html page getting curled here

    # grabbing all the videos in a channel is possible,
    # just requires the youtube data api which requires
    # a registration with google that I dont wanna do
    # for this

    media_type="$1"
    account_type="$2"
    youtube_group="$3"

    if [ "$account_type" == 'channel' ]; then account_prefix='c'
    elif [ "$account_type" == 'user' ]; then account_prefix='user'
    fi

    group_url="https://www.youtube.com/$account_prefix/$youtube_group/videos"

    if [ "$(curl -s -I "$group_url" | head -1 | awk '{print $2}')" == '200' ]; then
        print_message stdout 'youtube group found' "$youtube_group"
        video_ids=$(curl -s "$group_url" \
            | egrep -o '"videoId":"[A-Za-z0-9_-]{1,}"' \
            | sort -u \
            | cut -d'"' -f4)

        for vid in $video_ids; do
            youtube_download_from_url "$media_type" "https://www.youtube.com/watch?v=$vid"

        done

    else
        print_message stderr 'no youtube page found for' "$youtube_group"

    fi
}
