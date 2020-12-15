#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/eslabs.ini"

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
      - image: polkaned/expressvpn:latest
        name: expressvpn
        env:
        - name: ACTIVATION_CODE
          value: "${EXPRESSVPN_ACTIVATION_CODE}"
        - name: SERVER
          value: "${EXPRESSVPN_SERVER_CODE}"
        stdin: true
        tty: true
        command: ['/bin/bash']
        lifecycle:
          postStart:
            exec:
              command: ['/bin/bash', '/tmp/entrypoint.sh']
        securityContext:
          capabilities:
            add:
            - NET_ADMIN
          privileged: true
        volumeMounts:
        - name: k8s-vol-tun-dev
          mountPath: /dev/net/tun
      - image: sameersbn/squid:latest
        name: squid
        ports:
        - containerPort: 3128
        volumeMounts:
        - name: squid-config
          mountPath: /etc/squid/squid.conf
          subPath: squid.conf
      - image: linuxserver/deluge:latest
        name: deluge
        env:
        - name: PUID
          value: "1000"
        - name: PGID
          value: "1000"
        - name:  TZ
          value: "${DOCKER_TIMEZONE}"
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
      - name: squid-config
        configMap:
          name: squid-config-map
      - name: k8s-vol-deluge-downloads
        hostPath:
          path: "${DELUGE_DOWNLOAD_DIR}"
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
