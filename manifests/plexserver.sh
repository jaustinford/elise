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
    app: plexserver
  ports:
  - protocol: TCP
    port: 32400
    targetPort: 32400
    nodePort: 32400
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: plexserver
  namespace: eslabs
  labels:
    app: plexserver
spec:
  replicas: 1
  selector:
    matchLabels:
      app: plexserver
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: plexserver
    spec:
      containers:
      - image: plexinc/pms-docker:latest
        name: plexserver
        env:
        - name:  TZ
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
      volumes:
      - name: k8s-vol-plexserver-config
        iscsi:
          targetPortal: 172.16.17.4
          iqn: iqn.2013-03.com.wdc:elysianskies:k8s-vol-plexserver-config
          lun: 0
          fsType: ext4
          readOnly: false
          chapAuthDiscovery: false
          chapAuthSession: true
          secretRef:
             name: tvault-iscsi-chap
      - name: k8s-vol-plexserver-transcode
        iscsi:
          targetPortal: 172.16.17.4
          iqn: iqn.2013-03.com.wdc:elysianskies:k8s-vol-plexserver-transcode
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
      nodeSelector:
          kubernetes.io/hostname: ${PLEX_AFFINITY_NODE}
EOF
