alias arnold="echo 'Arnold says...'; while sleep 5; do tautulli_api_execute arnold | jq '.response.data'; done"
alias eslabs_connect="eslabs_vpn_generate_credentials; eslabs_vpn_generate_config; eslabs_vpn_connect"
alias eslabs_deploy="${ELISE_ROOT_DIR}/scripts/eslabs.sh deploy"
alias eslabs_destroy="${ELISE_ROOT_DIR}/scripts/eslabs.sh destroy"
alias eslabs_nuke="countdown_to_cmd \"${ELISE_ROOT_DIR}/scripts/eslabs.sh stop; ${ELISE_ROOT_DIR}/scripts/eslabs.sh destroy yes; ${ELISE_ROOT_DIR}/scripts/eslabs.sh deploy\""
alias eslabs_shutdown="${ELISE_ROOT_DIR}/scripts/eslabs.sh shutdown"
alias eslabs_stop="${ELISE_ROOT_DIR}/scripts/eslabs.sh stop"
