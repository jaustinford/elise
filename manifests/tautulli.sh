#!/usr/bin/env bash

set -eu

. "${ELISE_ROOT_DIR}/src/elise.ini"

cat <<EOF | kubectl "$1" -f -
---
apiVersion: v1
kind: Service
metadata:
  name: tautulli
  namespace: eslabs
spec:
  type: ClusterIP
  selector:
    app: tautulli
  ports:
  - protocol: TCP
    port: 8181
    targetPort: 8181
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tautulli
  namespace: eslabs
  labels:
    app: tautulli
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tautulli
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: tautulli
    spec:
      containers:
      - image: linuxserver/tautulli:latest
        name: tautulli
        env:
        - name:  TZ
          value: "${DOCKER_TIMEZONE}"
        - name: PUID
          value: "1000"
        - name: PGID
          value: "1000"
        ports:
        - containerPort: 8181
        volumeMounts:
        - name: k8s-vol-tautulli
          mountPath: /config
      volumes:
      - name: k8s-vol-tautulli
        iscsi:
          targetPortal: 172.16.17.4
          iqn: iqn.2013-03.com.wdc:elysianskies:k8s-vol-tautulli
          lun: 0
          fsType: ext4
          readOnly: false
          chapAuthDiscovery: false
          chapAuthSession: true
          secretRef:
             name: tvault-iscsi-chap
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-eslabs-tautulli
  namespace: eslabs
spec:
  rules:
  - http:
      paths:
      - path: /tautulli/
        pathType: Prefix
        backend:
          service:
            name: tautulli
            port:
              number: 8181
EOF
