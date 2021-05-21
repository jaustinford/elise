#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"

cat <<EOF | kubectl "$1" -f -
---
apiVersion: v1
kind: Service
metadata:
  name: filebrowser
  namespace: eslabs
spec:
  type: ClusterIP
  selector:
    app: filebrowser
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: filebrowser-config-map
  namespace: eslabs
data:
  filebrowser.json: |
    {
      "port": 80,
      "baseURL": "/tvault",
      "address": "",
      "log": "stdout",
      "database": "/tvault/database.db",
      "root": "/tvault"
    }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: filebrowser
  namespace: eslabs
  labels:
    app: filebrowser
spec:
  replicas: 1
  selector:
    matchLabels:
      app: filebrowser
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: filebrowser
    spec:
      dnsPolicy: Default
      containers:
        - image: filebrowser/filebrowser:latest
          name: filebrowser
          env:
            - name: TZ
              value: "${DOCKER_TIMEZONE}"
          volumeMounts:
            - name: tvault
              mountPath: /tvault
            - name: filebrowser-config
              mountPath: /.filebrowser.json
              subPath: filebrowser.json
      volumes:
        - name: tvault
          hostPath:
            path: /mnt/tvault
        - name: filebrowser-config
          configMap:
            name: filebrowser-config-map
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-eslabs-filebrowser
  namespace: eslabs
spec:
  rules:
    - http:
        paths:
          - path: /tvault
            pathType: Prefix
            backend:
              service:
                name: filebrowser
                port:
                  number: 80
EOF
