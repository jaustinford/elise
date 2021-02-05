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
  certbot.sh: |
    if [ ! -d '/etc/letsencrypt/live/${LAB_FQDN}' ]; then
        mkdir -p /usr/local/apache2/htdocs/.well-known/acme-challenge
        cd /usr/local/apache2/htdocs/.well-known/acme-challenge
        certbot certonly -d ${LAB_FQDN} -m $(git config -l | egrep ^user.email | cut -d'=' -f2) \
            --webroot --webroot-path='/usr/local/apache2/htdocs' --agree-tos --non-interactive

    fi
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
      containers:
        - image: httpd:latest
          name: acme
          env:
            - name: TZ
              value: "${DOCKER_TIMEZONE}"
          command: ['/bin/bash']
          args:
            - '-c'
            - >
              apt-get update -y;
              apt-get install -y certbot;
              /tmp/certbot.sh;
              httpd-foreground
          volumeMounts:
            - name: acme-configmap
              mountPath: /usr/local/apache2/htdocs/index.html
              subPath: index.html
            - name: acme-configmap
              mountPath: /tmp/certbot.sh
              subPath: certbot.sh
            - name: letsencrypt
              mountPath: /etc/letsencrypt
      volumes:
        - name: acme-configmap
          configMap:
            name: acme-configmap
            defaultMode: 0755
        - name: letsencrypt
          hostPath:
            path: ${LAB_SSL_DIR}
EOF
