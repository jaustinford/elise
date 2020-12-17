#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.ini"

#EXPRESSVPN_CERT=$(echo ${EXPRESSVPN_CERT} | base64 -d)
#EXPRESSVPN_KEY=$(echo ${EXPRESSVPN_KEY} | base64 -d)
#EXPRESSVPN_TLS=$(echo ${EXPRESSVPN_TLS} | base64 -d)
#EXPRESSVPN_CA=$(echo ${EXPRESSVPN_CA} | base64 -d)

cat <<EOF | kubectl "$1" -f -
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
    remote ${EXPRESSVPN_SERVER}-ca-version-2.expressnetw.com 1195
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
    ${EXPRESSVPN_CERT}
    </cert>
    <key>
    ${EXPRESSVPN_KEY}
    </key>
    <tls-auth>
    ${EXPRESSVPN_TLS}
    </tls-auth>
    <ca>
    ${EXPRESSVPN_CA}
    </ca>
EOF
