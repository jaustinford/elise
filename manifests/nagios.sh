#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"

cat <<EOF | kubectl "$1" -f -
---
apiVersion: v1
kind: Service
metadata:
  name: nagios
  namespace: eslabs
spec:
  type: ClusterIP
  selector:
    app: nagios
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nagios
  namespace: eslabs
  labels:
    app: nagios
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nagios
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: nagios
    spec:
      containers:
        - image: jasonrivers/nagios:latest
          name: nagios
          env:
            - name: TZ
              value: "${DOCKER_TIMEZONE}"
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-eslabs-nagios
  namespace: eslabs
spec:
  rules:
    - http:
        paths:
          - path: /nagios
            pathType: Prefix
            backend:
              service:
                name: nagios
                port:
                  number: 80
EOF
