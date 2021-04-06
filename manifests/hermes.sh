#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"

cat <<EOF | kubectl "$1" -f -
---
apiVersion: v1
kind: Service
metadata:
  name: hermes
  namespace: eslabs
spec:
  type: NodePort
  selector:
    app: hermes
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: ${KUBE_NODEPORT_HERMES}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: hermes-configmap
  namespace: eslabs
data:
  index.html: |
    <html>
    <body style="background-color:LightGray;">
    <center>
        <br /><br /><br /><br />
        <h1 style="color:green; font-family:Consolas;">${LAB_APACHE_MOTD}</h1>
    </body>
    </html>
  certbot.sh: |
    #!/usr/bin/env bash

    MODE="\$1"

    if [ "\${MODE}" == 'generate' ]; then
        WEBROOT='/usr/local/apache2/htdocs'
        mkdir -p "\${WEBROOT}/.well-known/acme-challenge"
        chmod 777 "\${WEBROOT}/.well-known/acme-challenge"

        for item in \${LAB_SSL_DOMAINS[@]}; do
            DOMAINS+="\$item,"

        done

        DOMAINS=\$(echo "\${DOMAINS}" | sed -E 's/,$//g')

        certbot certonly \
            --domains "\${DOMAINS}" \
            --email '$(git config -l | egrep ^user.email | cut -d'=' -f2)' \
            --webroot --webroot-path="\${WEBROOT}" \
            --agree-tos \
            --non-interactive

    elif [ "\${MODE}" == 'renew' ]; then
        certbot renew \
            --agree-tos \
            --non-interactive

    fi

    cat "/etc/letsencrypt/live/\${LAB_FQDN}/fullchain.pem" > /tmp/tvault-ssl/nginx.crt
    cat "/etc/letsencrypt/live/\${LAB_FQDN}/privkey.pem" > /tmp/tvault-ssl/nginx.crt.key
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hermes
  namespace: eslabs
  labels:
    app: hermes
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hermes
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: hermes
    spec:
      containers:
        - image: httpd:latest
          name: hermes
          env:
            - name: TZ
              value: "${DOCKER_TIMEZONE}"
            - name: LAB_FQDN
              value: "${LAB_FQDN}"
            - name: LAB_SSL_DOMAINS
              value: "${LAB_SSL_DOMAINS[@]}"
          command: ['/bin/bash']
          args:
            - '-c'
            - >
              apt-get update -y;
              apt-get install -y certbot;
              httpd-foreground
          volumeMounts:
            - name: hermes-configmap
              mountPath: /usr/local/apache2/htdocs/index.html
              subPath: index.html
            - name: hermes-configmap
              mountPath: /tmp/certbot.sh
              subPath: certbot.sh
            - name: k8s-vol-hermes-letsencrypt
              mountPath: /etc/letsencrypt
            - name: tvault-ssl
              mountPath: /tmp/tvault-ssl
      volumes:
        - name: k8s-vol-hermes-letsencrypt
          iscsi:
            targetPortal: ${ISCSI_PORTAL}
            iqn: ${ISCSI_IQN}:k8s-vol-hermes-letsencrypt
            lun: 0
            fsType: ext4
            readOnly: false
            chapAuthDiscovery: false
            chapAuthSession: true
            secretRef:
              name: tvault-iscsi-chap
        - name: tvault-ssl
          hostPath:
            path: /mnt/tvault/es-labs/ssl
        - name: hermes-configmap
          configMap:
            name: hermes-configmap
            defaultMode: 0777
EOF
