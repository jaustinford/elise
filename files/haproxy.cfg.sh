#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"

HAPROXY_CFG=$(cat <<EOF
###########################################
# haproxy
###########################################

global
    maxconn 100
    log /dev/log local0
    user root
    group root
    nbthread 4
    cpu-map auto:1/1-4 0-3
    ssl-default-bind-ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256
    ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

defaults
    timeout http-request 5s
    timeout connect 5s
    timeout server 10s
    timeout client 30s
    log global
    mode http
    option httplog
    maxconn 20

###########################################
# acme apache
###########################################

frontend acme_apache
    bind *:80
    mode http
    option forwardfor
    default_backend acme_apache_nodeports

backend acme_apache_nodeports
    balance roundrobin
    default-server check maxconn 20
    server kube01.labs.elysianskies.com 172.16.17.6:${KUBE_NODEPORT_ACME} check fall 3 rise 2
    server kube02.labs.elysianskies.com 172.16.17.7:${KUBE_NODEPORT_ACME} check fall 3 rise 2

###########################################
# nginx ingress controller
###########################################

frontend nginx_ingress_controller
    bind *:443 ssl crt /usr/local/etc/haproxy/nginx.crt
    mode http
    stats enable
    stats realm eslabs\ haproxy\ statistics
    stats hide-version
    stats uri ${HAPROXY_STATS_URI}
    stats auth ${HAPROXY_STATS_USERNAME}:${HAPROXY_STATS_PASSWORD}
    option forwardfor
    acl https ssl_fc
    http-request set-header X-Forwarded-Proto https if https
    http-request set-header X-Forwarded-Proto http if !https
    default_backend nginx_ingress_controller_nodeports

backend nginx_ingress_controller_nodeports
    balance roundrobin
    default-server check maxconn 20
    server kube01.labs.elysianskies.com 172.16.17.6:${KUBE_NODEPORT_INGRESS} check fall 3 rise 2
    server kube02.labs.elysianskies.com 172.16.17.7:${KUBE_NODEPORT_INGRESS} check fall 3 rise 2

###########################################
# plexserver
###########################################

frontend plexserver
    bind *:32401
    mode tcp
    option tcplog
    default_backend plexserver_nodeports

backend plexserver_nodeports
    mode tcp
    balance roundrobin
    default-server check maxconn 20
    server kube01.labs.elysianskies.com 172.16.17.6:${KUBE_NODEPORT_PLEXSERVER} check fall 3 rise 2
    server kube02.labs.elysianskies.com 172.16.17.7:${KUBE_NODEPORT_PLEXSERVER} check fall 3 rise 2

###########################################
# squid proxy
###########################################

frontend squid_proxy
    bind *:3128
    mode tcp
    option tcplog
    default_backend squid_proxy_nodeports

backend squid_proxy_nodeports
    mode tcp
    balance roundrobin
    default-server check maxconn 100
    server kube01.labs.elysianskies.com 172.16.17.6:${KUBE_NODEPORT_SQUID} check fall 3 rise 2
    server kube02.labs.elysianskies.com 172.16.17.7:${KUBE_NODEPORT_SQUID} check fall 3 rise 2
EOF
)
