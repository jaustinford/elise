#!/usr/bin/env bash

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
      nodePort: ${KUBE_NODEPORT_ACME}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: acme-configmap
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

    WEBROOT='/usr/local/apache2/htdocs'
    mkdir -p \${WEBROOT}/.well-known/acme-challenge
    chmod 777 \${WEBROOT}/.well-known/acme-challenge

    for item in \${LAB_SSL_DOMAINS[@]}; do
        DOMAINS+="\$item,"

    done

    DOMAINS=\$(echo "\${DOMAINS}" | sed -E 's/,$//g')

    certbot certonly \
        --domains "\${DOMAINS}" \
        --email '$(git config -l | egrep ^user.email | cut -d'=' -f2)' \
        --webroot --webroot-path="\${WEBROOT}" \
        --agree-tos --non-interactive
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
            - name: acme-configmap
              mountPath: /usr/local/apache2/htdocs/index.html
              subPath: index.html
            - name: acme-configmap
              mountPath: /tmp/certbot.sh
              subPath: certbot.sh
            - name: k8s-vol-acme-letsencrypt
              mountPath: /etc/letsencrypt
      volumes:
        - name: k8s-vol-acme-letsencrypt
          iscsi:
            targetPortal: 172.16.17.4
            iqn: iqn.2013-03.com.wdc:elysianskies:k8s-vol-acme-letsencrypt
            lun: 0
            fsType: ext4
            readOnly: false
            chapAuthDiscovery: false
            chapAuthSession: true
            secretRef:
              name: tvault-iscsi-chap
        - name: acme-configmap
          configMap:
            name: acme-configmap
            defaultMode: 0777
EOF
