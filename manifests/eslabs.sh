#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.env"

cat <<EOF | kubectl "$1" -f -
---
apiVersion: v1
kind: Namespace
metadata:
  name: eslabs
---
apiVersion: v1
kind: Secret
metadata:
  name: tvault-iscsi-chap
  namespace: eslabs
type: 'kubernetes.io/iscsi-chap'
data:
  node.session.auth.username: $(echo ${ISCSI_CHAP_SESSION_USERNAME} | base64)
  node.session.auth.password: $(echo ${ISCSI_CHAP_SESSION_PASSWORD} | base64)
EOF
