#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/eslabs.ini"

cat <<EOF | kubectl "$1" -f -
---
apiVersion: v1
kind: Service
metadata:
  name: pihole
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
  name: pihole
  namespace: eslabs
subsets:
- addresses:
  - ip: 172.16.17.10
  ports:
  - port: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-eslabs-pihole
  namespace: eslabs
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /\$2
spec:
  rules:
  - http:
      paths:
      - path: /pihole(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: pihole
            port:
              number: 8080
EOF
