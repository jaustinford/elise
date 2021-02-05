#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"

# entries in SANS must have public DNS
# record of some kind; using CNAME
SANS=(
  "kube00"
)

DOMAINS="${LAB_FQDN}"

for host in ${SANS[@]}; do
    DOMAINS+=",${host}.${LAB_FQDN}"

done

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
        certbot certonly -d '${DOMAINS}' -m '$(git config -l | egrep ^user.email | cut -d'=' -f2)' \
            --webroot --webroot-path='/usr/local/apache2/htdocs' --agree-tos --non-interactive

    else
        serial=\$(openssl x509 -in /etc/letsencrypt/live/${LAB_FQDN}/fullchain.pem -noout -serial | cut -d'=' -f2)
        expiration=\$(openssl x509 -in /etc/letsencrypt/live/${LAB_FQDN}/fullchain.pem -noout -enddate | cut -d'=' -f2)
        sans=\$(openssl x509 -in /etc/letsencrypt/live/${LAB_FQDN}/fullchain.pem -noout -text \
            | grep 'X509v3 Subject Alternative Name' -A1 \
            | grep DNS\: \
            | sed 's/ DNS://g' \
            | awk '{print \$1}')

        echo "----------------------------------------------------------------------"
        echo "found certificate : ${LAB_FQDN}"
        echo "serial number     : \$serial"
        echo "expiration date   : \$expiration"
        echo "configured sans   : \$sans"
        echo "----------------------------------------------------------------------"

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
