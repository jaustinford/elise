 #!/usr/bin/env bash

# set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/kubernetes.sh"

MODE="$1"

pod_from_deployment 'eslabs' 'acme' 'wait'

if [ "${MODE}" == 'generate' ]; then
    kube_exec 'eslabs' "$pod" 'acme' 'rm -rf /etc/letsencrypt/*; /tmp/certbot.sh generate'

elif [ "${MODE}" == 'display' ]; then
    ssl_crt=$(echo | openssl s_client -connect ${LAB_FQDN}:443 2> /dev/null | openssl x509 2> /dev/null)

    if [ ! -z "$ssl_crt" ]; then
        serial=$(echo "$ssl_crt" | openssl x509 -noout -serial)
        enddate=$(echo "$ssl_crt" | openssl x509 -noout -enddate)
        subject=$(echo "$ssl_crt" | openssl x509 -noout -subject)
        subjectAltName=$(echo "$ssl_crt" | openssl x509 -noout -ext subjectAltName | egrep -o 'DNS:.*$')

        print_message 'stdout' 'ssl certificate found for' "${LAB_FQDN}"
        print_message 'stdout' 'ssl serial number' "$serial"
        print_message 'stdout' 'ssl expiration date' "$enddate"
        print_message 'stdout' 'ssl subject cn' "$subject"
        print_message 'stdout' 'ssl subject alt names' "$subjectAltName"

    else

        print_message 'stderr' 'no certificate found for' "${LAB_FQDN}"
        exit 1

    fi

fi
