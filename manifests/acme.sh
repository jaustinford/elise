#!/usr/bin/env bash

set -eu

. "${ELISE_ROOT_DIR}/src/elise.sh"

cat <<EOF | kubectl "$1" -f -
---
apiVersion: v1
kind: Service
metadata:
  name: acme
  namespace: eslabs
spec:
  type: NodePort
  selector:
    app: acme
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 32565
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: acme-configmap
  namespace: eslabs
data:
  index.html: |
    <html>
    <body>
    <center>
        <br /><br />
        <h3>IE1hZGUgeWEgbG9vayEgTm93IGZ1Y2sgb2ZmIQo=</h3>
    </body>
    </html>
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: acme
  namespace: eslabs
  labels:
    app: acme
spec:
  replicas: 1
  selector:
    matchLabels:
      app: acme
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: acme
    spec:
      securityContext:
        fsGroup: 0
      containers:
        - image: httpd:latest
          name: acme
          env:
            - name: TZ
              value: "${DOCKER_TIMEZONE}"
          volumeMounts:
            - name: acme-challenge
              mountPath: /usr/local/apache2/htdocs/.well-known/acme-challenge
            - name: acme-configmap
              mountPath: /usr/local/apache2/htdocs/index.html
              subPath: index.html

      volumes:
        - name: acme-challenge
          emptyDir: {}
        - name: acme-configmap
          configMap:
            name: acme-configmap
EOF
