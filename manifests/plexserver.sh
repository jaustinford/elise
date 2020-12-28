#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.env"

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
        ports:
        - containerPort: 32400
          protocol: TCP
        - containerPort: 3005
          protocol: TCP
        - containerPort: 8324
          protocol: TCP
        - containerPort: 32469
          protocol: TCP
        - containerPort: 1900
          protocol: UDP
        - containerPort: 32410
          protocol: UDP
        - containerPort: 32412
          protocol: UDP
        - containerPort: 32413
          protocol: UDP
        - containerPort: 32414
          protocol: UDP
        volumeMounts:
        - name: k8s-vol-plexserver-config
          mountPath: /config/Library/Application Support
        - name: k8s-vol-plexserver-transcode
          mountPath: /transcode
        - name: k8s-vol-plexserver-content-standup
          mountPath: /shares/tvault/video/standup
          readOnly: true
        - name: k8s-vol-plexserver-content-dj-recordings
          mountPath: /shares/tvault/video/dj-recordings
          readOnly: true
        - name: k8s-vol-plexserver-content-documentaries
          mountPath: /shares/tvault/video/documentaries
          readOnly: true
        - name: k8s-vol-plexserver-content-movies
          mountPath: /shares/tvault/video/movies
          readOnly: true
        - name: k8s-vol-plexserver-content-political-movies
          mountPath: /shares/tvault/video/political-movies
          readOnly: true
        - name: k8s-vol-plexserver-content-tv
          mountPath: /shares/tvault/video/tv
          readOnly: true
        - name: k8s-vol-plexserver-content-anime-movies
          mountPath: /shares/tvault/video/anime-movies
          readOnly: true
        - name: k8s-vol-plexserver-content-anime-tv
          mountPath: /shares/tvault/video/anime-tv
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
      - name: k8s-vol-plexserver-content-standup
        hostPath:
          path: /mnt/tvault/video/standup
      - name: k8s-vol-plexserver-content-dj-recordings
        hostPath:
          path: /mnt/tvault/video/dj-recordings
      - name: k8s-vol-plexserver-content-documentaries
        hostPath:
          path: /mnt/tvault/video/documentaries
      - name: k8s-vol-plexserver-content-movies
        hostPath:
          path: /mnt/tvault/video/movies
      - name: k8s-vol-plexserver-content-political-movies
        hostPath:
          path: /mnt/tvault/video/political-movies
      - name: k8s-vol-plexserver-content-tv
        hostPath:
          path: /mnt/tvault/video/tv
      - name: k8s-vol-plexserver-content-anime-movies
        hostPath:
          path: /mnt/tvault/video/anime-movies
      - name: k8s-vol-plexserver-content-anime-tv
        hostPath:
          path: /mnt/tvault/video/anime-tv
      nodeSelector:
          kubernetes.io/hostname: ${PLEX_AFFINITY_NODE}
EOF
