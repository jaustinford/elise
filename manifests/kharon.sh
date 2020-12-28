#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.env"

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
    nodePort: 30526
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: vpn-credentials-config-map
  namespace: eslabs
data:
  vpn.credentials: |
    ${KHARON_EXPRESSVPN_USERNAME}
    ${KHARON_EXPRESSVPN_PASSWORD}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: vpn-conf-config-map
  namespace: eslabs
data:
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
  name: squid-config-map
  namespace: eslabs
data:
  squid.conf: |
    http_access allow all
    http_port 3128
    coredump_dir /var/spool/squid
    refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
    refresh_pattern ^ftp:		1440	20%	10080
    refresh_pattern ^gopher:	1440	0%	1440
    refresh_pattern .		0	20%	4320
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
      containers:
      - image: dperson/openvpn-client:latest
        name: expressvpn
        env:
        - name: TZ
          value: "${DOCKER_TIMEZONE}"
        stdin: true
        tty: true
        command: ["/sbin/tini", "--", "/usr/bin/openvpn.sh", "-d"]
        securityContext:
          capabilities:
            add:
            - NET_ADMIN
          privileged: true
        volumeMounts:
        - name: k8s-vol-tun-dev
          mountPath: /dev/net/tun
        - name: vpn-conf
          mountPath: /vpn/vpn.conf
          subPath: vpn.conf
        - name: vpn-credentials
          mountPath: /vpn/vpn.credentials
          subPath: vpn.credentials
      - image: sameersbn/squid:latest
        name: squid
        env:
        - name: TZ
          value: "${DOCKER_TIMEZONE}"
        ports:
        - containerPort: 3128
        volumeMounts:
        - name: squid-config
          mountPath: /etc/squid/squid.conf
          subPath: squid.conf
      - image: linuxserver/deluge:latest
        name: deluge
        env:
        - name:  TZ
          value: "${DOCKER_TIMEZONE}"
        - name: PUID
          value: "1000"
        - name: PGID
          value: "1000"
        lifecycle:
          postStart:
            exec:
              command: ['/bin/bash', '-c', 'chmod 755 /root']
        volumeMounts:
        - name: k8s-vol-deluge-downloads
          mountPath: /root/Downloads
      volumes:
      - name: k8s-vol-tun-dev
        hostPath:
          path: /dev/net/tun
          type: CharDevice
      - name: vpn-conf
        configMap:
          name: vpn-conf-config-map
      - name: vpn-credentials
        configMap:
          name: vpn-credentials-config-map
      - name: squid-config
        configMap:
          name: squid-config-map
      - name: k8s-vol-deluge-downloads
        hostPath:
          path: "${KHARON_DELUGE_DOWNLOAD_DIR}"
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
