#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"

cat <<EOF | kubectl "$1" -f -
---
apiVersion: v1
kind: Service
metadata:
  name: plexserver
  namespace: eslabs
spec:
  externalTrafficPolicy: Local
  type: NodePort
  selector:
    app: plex
  ports:
    - protocol: TCP
      port: 32400
      targetPort: 32400
      nodePort: ${KUBE_NODEPORT_PLEXSERVER}
---
apiVersion: v1
kind: Service
metadata:
  name: tautulli
  namespace: eslabs
spec:
  type: ClusterIP
  selector:
    app: plex
  ports:
    - protocol: TCP
      port: 8181
      targetPort: 8181
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: plex
  namespace: eslabs
  labels:
    app: plex
spec:
  replicas: 1
  selector:
    matchLabels:
      app: plex
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: plex
    spec:
      dnsPolicy: Default
      containers:
        - image: plexinc/pms-docker:latest
          name: plexserver
          env:
            - name: TZ
              value: "${DOCKER_TIMEZONE}"
            - name: PLEX_CLAIM
              value: "${PLEX_CLAIM}"
          volumeMounts:
            - name: k8s-vol-plexserver-config
              mountPath: /config/Library/Application Support
            - name: k8s-vol-plexserver-transcode
              mountPath: /transcode
            - name: k8s-vol-plexserver-content
              mountPath: /shares/tvault/video
              readOnly: true
        - image: linuxserver/tautulli:latest
          name: tautulli
          env:
            - name: TZ
              value: "${DOCKER_TIMEZONE}"
          volumeMounts:
            - name: k8s-vol-tautulli
              mountPath: /config
      volumes:
        - name: k8s-vol-plexserver-config
          iscsi:
            targetPortal: ${ISCSI_PORTAL}
            iqn: ${ISCSI_IQN}:k8s-vol-plexserver-config
            lun: 0
            fsType: ext4
            readOnly: false
            chapAuthDiscovery: false
            chapAuthSession: true
            secretRef:
              name: tvault-iscsi-chap
        - name: k8s-vol-plexserver-transcode
          iscsi:
            targetPortal: ${ISCSI_PORTAL}
            iqn: ${ISCSI_IQN}:k8s-vol-plexserver-transcode
            lun: 0
            fsType: ext4
            readOnly: false
            chapAuthDiscovery: false
            chapAuthSession: true
            secretRef:
              name: tvault-iscsi-chap
        - name: k8s-vol-tautulli
          iscsi:
            targetPortal: ${ISCSI_PORTAL}
            iqn: ${ISCSI_IQN}:k8s-vol-tautulli
            lun: 0
            fsType: ext4
            readOnly: false
            chapAuthDiscovery: false
            chapAuthSession: true
            secretRef:
              name: tvault-iscsi-chap
        - name: k8s-vol-plexserver-content
          hostPath:
            path: /mnt/tvault/video
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-eslabs-tautulli
  namespace: eslabs
  annotations:
    nginx.ingress.kubernetes.io/configuration-snippet: |
        proxy_set_header X-Forwarded-Proto https;
spec:
  rules:
    - http:
        paths:
          - path: /tautulli
            pathType: Prefix
            backend:
              service:
                name: tautulli
                port:
                  number: 8181
EOF
