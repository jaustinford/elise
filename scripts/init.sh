#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/init.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

greeting 'austin'
ssh_key
ssh_client_config
kube_config "${ELISE_ROOT_DIR}"
add_local_dns_search "${LAB_FQDN}"
curl_test 'kubernetes ingress' 'https' "${LAB_FQDN}" '/tvault'
curl_test 'plex media server' 'https' "${LAB_FQDN}" ':32400/web/index.html'
curl_test 'acme apache' 'http' "${LAB_FQDN}" '/'
