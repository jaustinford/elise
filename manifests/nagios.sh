#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"

NAGIOS_CREDENTIALS=$(htpasswd -n -b "${NAGIOS_USERNAME}" "${NAGIOS_PASSWORD}")

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
apiVersion: v1
kind: ConfigMap
metadata:
  name: nagios-configmap
  namespace: eslabs
data:
  htpasswd.users: |
    ${NAGIOS_CREDENTIALS}
  localhost.cfg: |
    # intentionally kept empty
  resource.cfg: |
    \$USER1\$=/opt/nagios/libexec
  eslabs.cfg: |
    define contact {
        contact_name        ${NAGIOS_USERNAME}
        use                 generic-contact
        alias               Nagios Admin
        email               j.austin.ford@gmail.com
    }
    define command {
        command_name        check_nrpe
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c \$ARG1\$
    }
    define host {
        host_name           manswitch01.labs.elysianskies.com
        address             172.16.17.16
        contacts            ${NAGIOS_USERNAME}
        max_check_attempts  ${NAGIOS_MAX_CHECK_ATTEMPTS}
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check-host-alive
    }
    define host {
        host_name           manswitch02.labs.elysianskies.com
        address             172.16.17.17
        contacts            ${NAGIOS_USERNAME}
        max_check_attempts  ${NAGIOS_MAX_CHECK_ATTEMPTS}
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check-host-alive
    }
    define host {
        host_name           manswitch03.labs.elysianskies.com
        address             172.16.17.18
        contacts            ${NAGIOS_USERNAME}
        max_check_attempts  ${NAGIOS_MAX_CHECK_ATTEMPTS}
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check-host-alive
    }
    define host {
        host_name           tvault.labs.elysianskies.com
        address             172.16.17.4
        contacts            ${NAGIOS_USERNAME}
        max_check_attempts  ${NAGIOS_MAX_CHECK_ATTEMPTS}
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check-host-alive
    }
    define host {
        host_name           kube00.labs.elysianskies.com
        address             172.16.17.20
        contacts            ${NAGIOS_USERNAME}
        max_check_attempts  ${NAGIOS_MAX_CHECK_ATTEMPTS}
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check-host-alive
    }
    define host {
        host_name           kube01.labs.elysianskies.com
        address             172.16.17.6
        contacts            ${NAGIOS_USERNAME}
        max_check_attempts  ${NAGIOS_MAX_CHECK_ATTEMPTS}
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check-host-alive
    }
    define host {
        host_name           kube02.labs.elysianskies.com
        address             172.16.17.7
        contacts            ${NAGIOS_USERNAME}
        max_check_attempts  ${NAGIOS_MAX_CHECK_ATTEMPTS}
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check-host-alive
    }
    define host {
        host_name           dns.labs.elysianskies.com
        address             172.16.17.10
        contacts            ${NAGIOS_USERNAME}
        max_check_attempts  ${NAGIOS_MAX_CHECK_ATTEMPTS}
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check-host-alive
    }
    define host {
        host_name           netmon.labs.elysianskies.com
        address             172.16.17.19
        contacts            ${NAGIOS_USERNAME}
        max_check_attempts  ${NAGIOS_MAX_CHECK_ATTEMPTS}
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check-host-alive
    }
    define host {
        host_name           watcher01.labs.elysianskies.com
        address             172.16.17.13
        contacts            ${NAGIOS_USERNAME}
        max_check_attempts  ${NAGIOS_MAX_CHECK_ATTEMPTS}
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check-host-alive
    }
    define host {
        host_name           watcher02.labs.elysianskies.com
        address             172.16.17.14
        contacts            ${NAGIOS_USERNAME}
        max_check_attempts  ${NAGIOS_MAX_CHECK_ATTEMPTS}
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check-host-alive
    }
    define hostgroup {
        hostgroup_name      eshosts
        members             kube00.labs.elysianskies.com,kube01.labs.elysianskies.com,kube02.labs.elysianskies.com,dns.labs.elysianskies.com,netmon.labs.elysianskies.com,watcher01.labs.elysianskies.com,watcher02.labs.elysianskies.com
    }
    define service {
        name                eslabs-service
        service_description default eslabs service
        max_check_attempts  ${NAGIOS_MAX_CHECK_ATTEMPTS}
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_period        24x7
        notification_period 24x7
        contacts            ${NAGIOS_USERNAME}
        register            0
    }
    define service {
        use                 eslabs-service
        hostgroup_name      eshosts
        service_description ping
        check_command       check_ping!100.0,20%!500.0,60%
    }
    define service {
        use                 eslabs-service
        hostgroup_name      eshosts
        service_description hdd
        check_command       check_nrpe!check_disk
    }
    define service {
        use                 eslabs-service
        hostgroup_name      eshosts
        service_description users
        check_command       check_nrpe!check_users
    }
    define service {
        use                 eslabs-service
        hostgroup_name      eshosts
        service_description processes
        check_command       check_nrpe!check_procs
    }
    define service {
        use                 eslabs-service
        hostgroup_name      eshosts
        service_description load
        check_command       check_nrpe!check_load
    }
    define service {
        use                 eslabs-service
        hostgroup_name      eshosts
        service_description memory
        check_command       check_nrpe!check_mem
    }
    define service {
        use                 eslabs-service
        hostgroup_name      eshosts
        service_description network traffic
        check_command       check_nrpe!check_int
    }
    define service {
        use                 eslabs-service
        hostgroup_name      eshosts
        service_description cpu temperature
        check_command       check_nrpe!check_temp
    }
    define service {
        use                 eslabs-service
        hostgroup_name      eshosts
        service_description uptime
        check_command       check_nrpe!check_uptime
    }
    define service {
        use                 eslabs-service
        hostgroup_name      eshosts
        service_description date
        check_command       check_nrpe!check_date
    }
    define service {
        use                 eslabs-service
        hostgroup_name      eshosts
        service_description ssh
        check_command       check_nrpe!check_ssh
    }
    define service {
        use                 eslabs-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - acme/apache
        check_command       check_nrpe!check_k8s_acme
    }
    define service {
        use                 eslabs-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - bigbrother/zoneminder
        check_command       check_nrpe!check_k8s_bigbrother
    }
    define service {
        use                 eslabs-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - filebrowser/apache
        check_command       check_nrpe!check_k8s_filebrowser
    }
    define service {
        use                 eslabs-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - kharon/expressvpn
        check_command       check_nrpe!check_k8s_kharon_expressvpn
    }
    define service {
        use                 eslabs-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - kharon/deluge
        check_command       check_nrpe!check_k8s_kharon_deluge
    }
    define service {
        use                 eslabs-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - kharon/squid
        check_command       check_nrpe!check_k8s_kharon_squid
    }
    define service {
        use                 eslabs-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - plex/plexserver
        check_command       check_nrpe!check_k8s_plex_plexserver
    }
    define service {
        use                 eslabs-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - plex/tautulli
        check_command       check_nrpe!check_k8s_plex_tautulli
    }
  nagios.conf: |
    ScriptAlias /nagios/cgi-bin "/opt/nagios/sbin"
    <Directory "/opt/nagios/sbin">
      SetEnv TZ "${DOCKER_TIMEZONE}"
      Options ExecCGI
      AllowOverride None
      <IfVersion >= 2.3>
          <RequireAll>
            Require all granted
            AuthName "Nagios Access"
            AuthType Basic
            AuthUserFile /opt/nagios/etc/htpasswd.users
            Require valid-user
          </RequireAll>
      </IfVersion>
      <IfVersion < 2.3>
          Order allow,deny
          Allow from all
          AuthName "Nagios Access"
          AuthType Basic
          AuthUserFile /opt/nagios/etc/htpasswd.users
          Require valid-user
      </IfVersion>
    </Directory>
    Alias /nagios "/opt/nagios/share"
    <Directory "/opt/nagios/share">
      Options None
      AllowOverride None
      <IfVersion >= 2.3>
          <RequireAll>
            Require all granted
            AuthName "Nagios Access"
            AuthType Basic
            AuthUserFile /opt/nagios/etc/htpasswd.users
            Require valid-user
          </RequireAll>
      </IfVersion>
      <IfVersion < 2.3>
          Order allow,deny
          Allow from all
          AuthName "Nagios Access"
          AuthType Basic
          AuthUserFile /opt/nagios/etc/htpasswd.users
          Require valid-user
      </IfVersion>
    </Directory>
  cgi.cfg: |
    main_config_file=/opt/nagios/etc/nagios.cfg
    physical_html_path=/opt/nagios/share
    url_html_path=/nagios
    show_context_help=0
    use_pending_states=1
    use_authentication=1
    use_ssl_authentication=0
    authorized_for_system_information=nagiosadmin
    authorized_for_configuration_information=nagiosadmin
    authorized_for_system_commands=nagiosadmin
    authorized_for_all_services=nagiosadmin
    authorized_for_all_hosts=nagiosadmin
    authorized_for_all_service_commands=nagiosadmin
    authorized_for_all_host_commands=nagiosadmin
    default_statusmap_layout=5
    default_statuswrl_layout=4
    ping_syntax=/bin/ping -n -U -c 5 \$HOSTADDRESS\$
    refresh_rate=${NAGIOS_REFRESH_RATE_SECONDS}
    result_limit=100
    escape_html_tags=1
    action_url_target=_self
    notes_url_target=_self
    lock_author_names=1
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
          volumeMounts:
            - name: nagios-config
              mountPath: /opt/nagios/etc/htpasswd.users
              subPath: htpasswd.users
            - name: nagios-config
              mountPath: /opt/nagios/etc/objects/localhost.cfg
              subPath: localhost.cfg
            - name: nagios-config
              mountPath: /opt/nagios/etc/resource.cfg
              subPath: resource.cfg
            - name: nagios-config
              mountPath: /opt/nagios/etc/conf.d/eslabs.cfg
              subPath: eslabs.cfg
            - name: nagios-config
              mountPath: /etc/apache2/sites-available/nagios.conf
              subPath: nagios.conf
            - name: nagios-config
              mountPath: /opt/nagios/etc/cgi.cfg
              subPath: cgi.cfg
      volumes:
        - name: nagios-config
          configMap:
            name: nagios-configmap
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
