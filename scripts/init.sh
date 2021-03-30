#!/usr/bin/env bash

# set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

greeting austin
ssh_key
ssh_client_config
add_local_dns_search "${LAB_FQDN}"
kube_config "${ELISE_ROOT_DIR}" "${LAB_FQDN}"
ensure_dropoff_folder
display_tvault_stats "$(pod_from_deployment eslabs plex)"
ssl_reader "${LAB_FQDN}" 443
curl_test 'kubernetes ingress' https "${LAB_FQDN}" '/tvault'
curl_test 'plex media server' https "${LAB_FQDN}" ':32400/web/index.html'
curl_test 'acme apache' http "${LAB_FQDN}" '/'
grab_loaded_vpn_server "$(pod_from_deployment eslabs kharon)"
find_wan_from_pod "$(pod_from_deployment eslabs kharon)"
