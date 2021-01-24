#!/usr/bin/env bash

set -eu

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"

OPTION="$1"
EMAIL="${GITHUB_COMMIT_EMAIL}"
DOMAIN="${LAB_FQDN}"
SANS=(
    "kube00"
)

new_cert () {
    DOMAINS="${DOMAIN}"

    for host in ${SANS[@]}; do
        DOMAINS+=",${host}.${DOMAIN}"
    done

    certbot certonly \
        -d "${DOMAINS}" \
        -m "${EMAIL}" \
        --manual \
        --agree-tos \
        --preferred-challenges dns
}

if [ "${OPTION}" == "new" ]; then
    new_cert

fi
