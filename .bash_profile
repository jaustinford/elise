#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/general.sh"

vars_ensure decrypted
PS1="  ${SHELL_STDERR_CODE}DOC "

if [ ! -z "${ELISE_PROFILE}" ]; then
    export PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin:/root/bin'
    export EDITOR='vim'
    export HISTTIMEFORMAT="%F %T "
    export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.m4a=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.oga=01;36:*.opus=01;36:*.spx=01;36:*.xspf=01;36:'

    if [ ! -z "${ENABLE_INIT}" ]; then
        clear
        "${ELISE_ROOT_DIR}/scripts/motd.sh"
        echo 'CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAuOjo6Oi4gICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAuOjo6Ojo6OjouICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDo6Ojo6Ojo6Ojo6ICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJzo6Ojo6Ojo6Ojo6Li4gICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgOjo6Ojo6Ojo6Ojo6Ojo6JyAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJzo6Ojo6Ojo6Ojo6LiAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC46Ojo6Ojo6Ojo6Ojo6OicgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC46Ojo6Ojo6Ojo6Oi4uLiAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA6Ojo6Ojo6Ojo6Ojo6OicnICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC46OjouICAgICAgICc6Ojo6Ojo6OicnOjo6OiAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC46Ojo6Ojo6Oi4gICAgICAnOjo6OjonICAnOjo6OiAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAuOjo6Oic6Ojo6Ojo6LiAgICA6Ojo6OiAgICAnOjo6Oi4gICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAuOjo6OjonICc6Ojo6Ojo6OjouIDo6Ojo6ICAgICAgJzo6Oi4gICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAuOjo6OjonICAgICAnOjo6Ojo6Ojo6Ljo6Ojo6ICAgICAgICc6Oi4gICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAuOjo6OicnICAgICAgICAgJzo6Ojo6Ojo6Ojo6Ojo6ICAgICAgICc6Oi4gICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgLjo6JycgICAgICAgICAgICAgICc6Ojo6Ojo6Ojo6OjogICAgICAgICA6OjouLi4gICAgICAKICAgICAgICAgICAgICAgICAgICAuLjo6OjogICAgICAgICAgICAgICAgICAnOjo6Ojo6Ojo6JyAgICAgICAgLjonICcnJycgICAgIAogICAgICAgICAgICAgICAgIC4uJycnJyc6JyAgICAgICAgICAgICAgICAgICAgJzo6Ojo6LicgICAgICAgICAgICAgICAgICAgICAgCgo=' | base64 -d
        greeting austin

    fi

    for dir in src aliases; do
        print_message stdout 'importing modules' "${ELISE_ROOT_DIR}/$dir"
        for item in $(find "${ELISE_ROOT_DIR}/$dir" -type f); do
            . "$item"

        done

    done

    ssh_key
    ssh_client_config
    add_local_dns "${LAB_FQDN}"
    kube_config "${ELISE_ROOT_DIR}" "${LAB_FQDN}"
    ensure_dropoff_folder

    if [ ! -z "${ENABLE_INIT}" ]; then
        display_tvault_stats "$(pod_from_deployment eslabs plex)"
        ssl_reader "${LAB_FQDN}" 443
        curl_test 'kubernetes ingress' https "${LAB_FQDN}" '/tvault'
        curl_test 'plex media server' https "${LAB_FQDN}" ':32400/web/index.html'
        curl_test 'hermes apache' http "${LAB_FQDN}" '/'
        print_message stdout 'tautulli active streams' $(tautulli_api_execute get_activity | jq -r '.response.data.stream_count')
        print_message stdout 'deluge active torrents' $(deluge_api_get_torrents | jq -r '.result.torrents[].hash' | wc -l)
        grab_loaded_vpn_server "$(pod_from_deployment eslabs kharon)"
        find_wan_from_pod "$(pod_from_deployment eslabs kharon)"

    fi

    USER_PROMPT="\[${SHELL_USER_PROMPT_CODE}\]elise\[${ECHO_RESET}\]"
    HIST_PROMPT="\[${SHELL_HIST_PROMPT_CODE}\]\!\[${ECHO_RESET}\]"
    HOST_PROMPT="\[${SHELL_HOST_PROMPT_CODE}\]${HOST_HOSTNAME}\[${ECHO_RESET}\]"
    CWD_PROMPT="\[${SHELL_CWD_PROMPT_CODE}\]\w\[${ECHO_RESET}\]"
    PS1="\n ( ${USER_PROMPT} ) ${HIST_PROMPT} ${HOST_PROMPT}:${CWD_PROMPT} $ "
    cd "${HOME}"

fi
