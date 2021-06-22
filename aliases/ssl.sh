alias ssl_eslabs_display="ssl_reader ${LAB_FQDN} 443"
alias ssl_eslabs_generate="kube_exec eslabs \$(pod_from_deployment eslabs hermes wait) hermes '/tmp/certbot.sh generate'"
alias ssl_eslabs_renew="kube_exec eslabs \$(pod_from_deployment eslabs hermes wait) hermes '/tmp/certbot.sh renew'"
alias ssl_eslabs_stage="kube_exec eslabs \$(pod_from_deployment eslabs hermes wait) hermes '/tmp/certbot.sh'"
