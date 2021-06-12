#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"

KHARON_DELUGE_SALT=$(cat /dev/urandom | tr -dc 'a-z0-9' | head -c 40)
KHARON_DELUGE_HASH=$(echo -n ${KHARON_DELUGE_SALT}${KHARON_DELUGE_PASSWORD} | sha1sum | awk '{print $1}')

cat <<EOF | kubectl "$1" -f -
---
apiVersion: v1
kind: Service
metadata:
  name: deluge
  namespace: eslabs
spec:
  type: ClusterIP
  selector:
    app: kharon
  ports:
    - protocol: TCP
      port: 8112
      targetPort: 8112
---
apiVersion: v1
kind: Service
metadata:
  name: squid
  namespace: eslabs
spec:
  type: NodePort
  selector:
    app: kharon
  ports:
    - protocol: TCP
      port: 3128
      targetPort: 3128
      nodePort: ${KUBE_NODEPORT_SQUID}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: kharon-configmap-expressvpn
  namespace: eslabs
data:
  gen-dns-record.sh: |
    #!/usr/bin/env bash

    manual_resolution=\$(nslookup ${KHARON_EXPRESSVPN_SERVER}-ca-version-2.expressnetw.com \
      | egrep '^Name' -A1 \
      | egrep '^Address' \
      | awk '{print \$2}' \
      | head -1)

    sleep 2
    echo "\$manual_resolution    ${KHARON_EXPRESSVPN_SERVER}-ca-version-2.expressnetw.com" >> /etc/hosts
  vpn.credentials: |
    ${KHARON_EXPRESSVPN_USERNAME}
    ${KHARON_EXPRESSVPN_PASSWORD}
  vpn.conf: |
    dev tun
    fast-io
    persist-key
    persist-tun
    nobind
    remote ${KHARON_EXPRESSVPN_SERVER}-ca-version-2.expressnetw.com 1195
    remote-random
    pull
    comp-lzo no
    tls-client
    verify-x509-name Server name-prefix
    ns-cert-type server
    key-direction 1
    route-method exe
    route-delay 2
    tun-mtu 1500
    fragment 1300
    mssfix 1200
    verb 3
    cipher AES-256-CBC
    keysize 256
    auth SHA512
    sndbuf 524288
    rcvbuf 524288
    auth-user-pass /vpn/vpn.credentials
    <cert>
    $(echo ${KHARON_EXPRESSVPN_CERT} | base64 -d)
    </cert>
    <key>
    $(echo ${KHARON_EXPRESSVPN_KEY} | base64 -d)
    </key>
    <tls-auth>
    $(echo ${KHARON_EXPRESSVPN_TLS} | base64 -d)
    </tls-auth>
    <ca>
    $(echo ${KHARON_EXPRESSVPN_CA} | base64 -d)
    </ca>
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: kharon-configmap-squid
  namespace: eslabs
data:
  check-vpn.sh: |
    while [ ! -d '/sys/devices/virtual/net/tun0' ]; do
        sleep 2

    done
  squid.conf: |
    http_access allow all
    http_port 3128
    coredump_dir /var/spool/squid
    refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
    refresh_pattern ^ftp:		1440	20%	10080
    refresh_pattern ^gopher:	1440	0%	1440
    refresh_pattern .		0	20%	4320
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: kharon-configmap-deluge
  namespace: eslabs
data:
  core.conf: |
    {
        "file": 1,
        "format": 1
    }{
        "add_paused": false,
        "allow_remote": false,
        "auto_manage_prefer_seeds": false,
        "auto_managed": true,
        "cache_expiry": 60,
        "cache_size": 512,
        "copy_torrent_file": true,
        "daemon_port": 58846,
        "del_copy_torrent_file": false,
        "dht": true,
        "dont_count_slow_torrents": false,
        "download_location": "/downloads/incoming",
        "download_location_paths_list": [],
        "enabled_plugins": [],
        "enc_in_policy": 1,
        "enc_level": 2,
        "enc_out_policy": 1,
        "geoip_db_location": "/usr/share/GeoIP/GeoIP.dat",
        "ignore_limits_on_local_network": true,
        "info_sent": 0.0,
        "listen_interface": "",
        "listen_ports": [
            6881,
            6891
        ],
        "listen_random_port": 63556,
        "listen_reuse_port": true,
        "listen_use_sys_port": false,
        "lsd": true,
        "max_active_downloading": ${KHARON_DELUGE_MAX_ACTIVE_DOWNLOADING},
        "max_active_limit": 8,
        "max_active_seeding": 5,
        "max_connections_global": 200,
        "max_connections_per_second": 20,
        "max_connections_per_torrent": -1,
        "max_download_speed": -1.0,
        "max_download_speed_per_torrent": -1,
        "max_half_open_connections": 50,
        "max_upload_slots_global": 4,
        "max_upload_slots_per_torrent": -1,
        "max_upload_speed": -1.0,
        "max_upload_speed_per_torrent": -1,
        "move_completed": true,
        "move_completed_path": "/downloads/completed",
        "move_completed_paths_list": [],
        "natpmp": true,
        "new_release_check": false,
        "outgoing_interface": "",
        "outgoing_ports": [
            0,
            0
        ],
        "path_chooser_accelerator_string": "Tab",
        "path_chooser_auto_complete_enabled": true,
        "path_chooser_max_popup_rows": 20,
        "path_chooser_show_chooser_button_on_localhost": true,
        "path_chooser_show_hidden_files": false,
        "peer_tos": "0x00",
        "plugins_location": "/config/plugins",
        "pre_allocate_storage": false,
        "prioritize_first_last_pieces": false,
        "proxy": {
            "anonymous_mode": false,
            "force_proxy": false,
            "hostname": "",
            "password": "",
            "port": 8080,
            "proxy_hostnames": true,
            "proxy_peer_connections": true,
            "proxy_tracker_connections": true,
            "type": 0,
            "username": ""
        },
        "queue_new_to_top": false,
        "random_outgoing_ports": true,
        "random_port": true,
        "rate_limit_ip_overhead": true,
        "remove_seed_at_ratio": false,
        "seed_time_limit": 180,
        "seed_time_ratio_limit": 7.0,
        "send_info": false,
        "sequential_download": false,
        "share_ratio_limit": 2.0,
        "shared": false,
        "stop_seed_at_ratio": false,
        "stop_seed_ratio": 2.0,
        "super_seeding": false,
        "torrentfiles_location": "/downloads/torrents",
        "upnp": true,
        "utpex": true
    }
  web.conf: |
    {
        "file": 2,
        "format": 1
    }{
        "base": "/",
        "cert": "ssl/daemon.cert",
        "default_daemon": "848a383a14b046a3995900613d4690c3",
        "enabled_plugins": [
          "webapi"
        ],
        "first_login": false,
        "https": false,
        "interface": "0.0.0.0",
        "language": "",
        "pkey": "ssl/daemon.pkey",
        "port": 8112,
        "pwd_salt": "${KHARON_DELUGE_SALT}",
        "pwd_sha1": "${KHARON_DELUGE_HASH}",
        "session_timeout": 3600,
        "sessions": {},
        "show_session_speed": true,
        "show_sidebar": false,
        "sidebar_multiple_filters": true,
        "sidebar_show_zero": false,
        "theme": "gray"
    }
  hostlist.conf: |
    {
        "file": 3,
        "format": 1
    }{
        "hosts": [
            [
                "848a383a14b046a3995900613d4690c3",
                "127.0.0.1",
                58846,
                "localclient",
                "f62fcc3650058b483a875a759b5ade21caec9325"
            ]
        ]
    }
  auth: |
    localclient:f62fcc3650058b483a875a759b5ade21caec9325:10
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kharon
  namespace: eslabs
  labels:
    app: kharon
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kharon
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: kharon
    spec:
      dnsPolicy: Default
      containers:
        - image: dperson/openvpn-client:latest
          name: expressvpn
          env:
            - name: TZ
              value: "${DOCKER_TIMEZONE}"
          command: ['/bin/bash']
          args:
            - '-c'
            - >
              /tmp/gen-dns-record.sh &&
              /sbin/tini -- /usr/bin/openvpn.sh -d
          securityContext:
            capabilities:
              add:
                - NET_ADMIN
            privileged: true
          volumeMounts:
            - name: k8s-vol-tun-dev
              mountPath: /dev/net/tun
            - name: kharon-configmap-expressvpn
              mountPath: /vpn/vpn.conf
              subPath: vpn.conf
            - name: kharon-configmap-expressvpn
              mountPath: /vpn/vpn.credentials
              subPath: vpn.credentials
            - name: kharon-configmap-expressvpn
              mountPath: /tmp/gen-dns-record.sh
              subPath: gen-dns-record.sh
        - image: sameersbn/squid:latest
          name: squid
          env:
            - name: TZ
              value: "${DOCKER_TIMEZONE}"
          command: ['/bin/bash']
          args:
            - '-c'
            - >
              /tmp/check-vpn.sh &&
              /sbin/entrypoint.sh
          volumeMounts:
            - name: kharon-configmap-squid
              mountPath: /etc/squid/squid.conf
              subPath: squid.conf
            - name: kharon-configmap-squid
              mountPath: /tmp/check-vpn.sh
              subPath: check-vpn.sh
        - image: linuxserver/deluge:latest
          name: deluge
          env:
            - name: TZ
              value: "${DOCKER_TIMEZONE}"
            - name: PUID
              value: "1000"
            - name: PGID
              value: "1000"
          volumeMounts:
            - name: deluge-downloads
              mountPath: /downloads
            - name: deluge-plugins
              mountPath: /config/plugins
            - name: kharon-configmap-deluge
              mountPath: /config/core.conf
              subPath: core.conf
            - name: kharon-configmap-deluge
              mountPath: /config/web.conf
              subPath: web.conf
            - name: kharon-configmap-deluge
              mountPath: /config/hostlist.conf
              subPath: hostlist.conf
            - name: kharon-configmap-deluge
              mountPath: /config/auth
              subPath: auth
      volumes:
        - name: k8s-vol-tun-dev
          hostPath:
            path: /dev/net/tun
            type: CharDevice
        - name: kharon-configmap-expressvpn
          configMap:
            name: kharon-configmap-expressvpn
            defaultMode: 0755
        - name: kharon-configmap-squid
          configMap:
            name: kharon-configmap-squid
            defaultMode: 0755
        - name: kharon-configmap-deluge
          configMap:
            name: kharon-configmap-deluge
            defaultMode: 0644
        - name: deluge-downloads
          hostPath:
            path: "${KHARON_DELUGE_DOWNLOAD_DIR}"
        - name: deluge-plugins
          hostPath:
            path: "${KHARON_DELUGE_PLUGINS_DIR}"
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-eslabs-deluge
  namespace: eslabs
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /\$2
    nginx.ingress.kubernetes.io/configuration-snippet: |
        proxy_set_header  X-Deluge-Base     "/deluge/";
        proxy_set_header Accept-Encoding "";
        sub_filter
        '</head>'
        '<link rel="stylesheet" type="text/css" href="https://halianelf.github.io/Deluge-Dark/deluge.css">
        </head>';
        sub_filter_once on;
spec:
  rules:
    - http:
        paths:
          - path: /deluge(/|$)(.*)
            pathType: Prefix
            backend:
              service:
                name: deluge
                port:
                  number: 8112
EOF
