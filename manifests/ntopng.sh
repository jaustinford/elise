#!/usr/bin/env bash

. "${SHELL_ROOT_DIR}/src/eslabs.ini"

cat <<EOF | kubectl "$1" -f -
---
apiVersion: v1
kind: Service
metadata:
  name: ntopng
  namespace: eslabs
spec:
  type: ClusterIP
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 8080
---
apiVersion: v1
kind: Endpoints
metadata:
  name: ntopng
  namespace: eslabs
subsets:
- addresses:
  - ip: 172.16.17.19
  ports:
  - port: 3000
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-eslabs-ntopng
  namespace: eslabs
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /\$2
spec:
  rules:
  - http:
      paths:
      - path: /ntopng(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: ntopng
            port:
              number: 8080
EOF
