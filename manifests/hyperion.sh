#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"

cat <<EOF | kubectl "$1" -f -
---
apiVersion: v1
kind: Service
metadata:
  name: hyperion
  namespace: eslabs
spec:
  type: ClusterIP
  selector:
    app: hyperion
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hyperion
  namespace: eslabs
  labels:
    app: hyperion
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hyperion
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: hyperion
    spec:
      dnsPolicy: Default
      containers:
        - image: dlandon/zoneminder:latest
          name: hyperion
          env:
            - name: TZ
              value: "${DOCKER_TIMEZONE}"
            - name: PUID
              value: "99"
            - name: PGID
              value: "100"
            - name: INSTALL_HOOK
              value: "0"
            - name: INSTALL_FACE
              value: "0"
            - name: INSTALL_TINY_YOLOV3
              value: "0"
            - name: INSTALL_YOLOV3
              value: "0"
            - name: INSTALL_TINY_YOLOV4
              value: "0"
            - name: INSTALL_YOLOV4
              value: "0"
            - name: MULTI_PORT_START
              value: "0"
            - name: MULTI_PORT_END
              value: "0"
          securityContext:
            privileged: true
          volumeMounts:
            - name: k8s-vol-hyperion-config
              mountPath: /config
            - name: tmpfs-shm
              mountPath: /dev/shm
      volumes:
        - name: k8s-vol-hyperion-config
          iscsi:
            targetPortal: ${ISCSI_PORTAL}
            iqn: ${ISCSI_IQN}:k8s-vol-hyperion-config
            lun: 0
            fsType: ext4
            readOnly: false
            chapAuthDiscovery: false
            chapAuthSession: true
            secretRef:
              name: tvault-iscsi-chap
        - name: tmpfs-shm
          emptyDir:
            medium: Memory
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-eslabs-hyperion
  namespace: eslabs
spec:
  rules:
    - http:
        paths:
          - path: /zm(/|$)(.*)
            pathType: Prefix
            backend:
              service:
                name: hyperion
                port:
                  number: 80
EOF
