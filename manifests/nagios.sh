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
  contacts.cfg: |
    define contact {
        contact_name        ${NAGIOS_USERNAME}
        use                 generic-contact
        alias               Nagios Admin
        email               j.austin.ford@gmail.com
    }
    define contactgroup {
        contactgroup_name   admins
        alias               Nagios Administrators
        members             ${NAGIOS_USERNAME}
    }
  commands.cfg: |
    define command {
        command_name        notify-host-by-email
        command_line        /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: \$NOTIFICATIONTYPE\$\nHost: \$HOSTNAME\$\nState: \$HOSTSTATE\$\nAddress: \$HOSTADDRESS\$\nInfo: \$HOSTOUTPUT\$\n\nDate/Time: \$LONGDATETIME\$\n" | /usr/bin/mail -s "** \$NOTIFICATIONTYPE\$ Host Alert: \$HOSTNAME\$ is \$HOSTSTATE\$ **" \$CONTACTEMAIL\$
    }
    define command {
        command_name        notify-service-by-email
        command_line        /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: \$NOTIFICATIONTYPE\$\n\nService: \$SERVICEDESC\$\nHost: \$HOSTALIAS\$\nAddress: \$HOSTADDRESS\$\nState: \$SERVICESTATE\$\n\nDate/Time: \$LONGDATETIME\$\n\nAdditional Info:\n\n\$SERVICEOUTPUT\$\n" | /usr/bin/mail -s "** \$NOTIFICATIONTYPE\$ Service Alert: \$HOSTALIAS\$/\$SERVICEDESC\$ is \$SERVICESTATE\$ **" \$CONTACTEMAIL\$
    }
    define command {
        command_name        check-host-alive
        command_line        \$USER1\$/check_ping -H \$HOSTADDRESS\$ -w 3000.0,80% -c 5000.0,100% -p 5
    }
    define command {
        command_name        check_ping
        command_line        \$USER1\$/check_ping -H \$HOSTADDRESS\$ -w \$ARG1\$ -c \$ARG2\$ -p 5
    }
    define command {
        command_name        check_nrpe
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c \$ARG1\$
    }
    define command {
        command_name        check_disk
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_disk
    }
    define command {
        command_name        check_load
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_load
    }
    define command {
        command_name        check_procs
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_procs
    }
    define command {
        command_name        check_users
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_users
    }
    define command {
        command_name        check_mem
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_mem
    }
    define command {
        command_name        check_int
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_int
    }
    define command {
        command_name        check_temp
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_temp
    }
    define command {
        command_name        check_uptime
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_uptime
    }
    define command {
        command_name        check_date
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_date
    }
    define command {
        command_name        check_ssh
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_ssh
    }
    define command {
        command_name        check_k8s_acme
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_k8s_acme
    }
    define command {
        command_name        check_k8s_bigbrother
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_k8s_bigbrother
    }
    define command {
        command_name        check_k8s_filebrowser
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_k8s_filebrowser
    }
    define command {
        command_name        check_k8s_kharon_expressvpn
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_k8s_kharon_expressvpn
    }
    define command {
        command_name        check_k8s_kharon_deluge
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_k8s_kharon_deluge
    }
    define command {
        command_name        check_k8s_kharon_squid
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_k8s_kharon_squid
    }
    define command {
        command_name        check_k8s_plex_plexserver
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_k8s_plex_plexserver
    }
    define command {
        command_name        check_k8s_plex_tautulli
        command_line        \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c check_k8s_plex_tautulli
    }
  hosts.cfg: |
    define host {
      host_name             kube00.labs.elysianskies.com
      alias                 kube00.labs.elysianskies.com
      display_name          kube00.labs.elysianskies.com
      address               172.16.17.20
      contacts              ${NAGIOS_USERNAME}
      max_check_attempts    3
      check_command         check-host-alive
    }
    define host {
      host_name             kube01.labs.elysianskies.com
      alias                 kube01.labs.elysianskies.com
      display_name          kube01.labs.elysianskies.com
      address               172.16.17.6
      contacts              ${NAGIOS_USERNAME}
      max_check_attempts    3
      check_command         check-host-alive
    }
    define host {
      host_name             kube02.labs.elysianskies.com
      alias                 kube02.labs.elysianskies.com
      display_name          kube02.labs.elysianskies.com
      address               172.16.17.7
      contacts              ${NAGIOS_USERNAME}
      max_check_attempts    3
      check_command         check-host-alive
    }
    define host {
      host_name             dns.labs.elysianskies.com
      alias                 dns.labs.elysianskies.com
      display_name          dns.labs.elysianskies.com
      address               172.16.17.10
      contacts              ${NAGIOS_USERNAME}
      max_check_attempts    3
      check_command         check-host-alive
    }
    define host {
      host_name             netmon.labs.elysianskies.com
      alias                 netmon.labs.elysianskies.com
      display_name          netmon.labs.elysianskies.com
      address               172.16.17.19
      contacts              ${NAGIOS_USERNAME}
      max_check_attempts    3
      check_command         check-host-alive
    }
    define host {
      host_name             watcher01.labs.elysianskies.com
      alias                 watcher01.labs.elysianskies.com
      display_name          watcher01.labs.elysianskies.com
      address               172.16.17.13
      contacts              ${NAGIOS_USERNAME}
      max_check_attempts    3
      check_command         check-host-alive
    }
    define host {
      host_name             watcher02.labs.elysianskies.com
      alias                 watcher02.labs.elysianskies.com
      display_name          watcher02.labs.elysianskies.com
      address               172.16.17.14
      contacts              ${NAGIOS_USERNAME}
      max_check_attempts    3
      check_command         check-host-alive
    }
  services.cfg: |
    define service {
        use                 generic-service
        host_name           *
        service_description ping
        check_command       check_ping!100.0,20%!500.0,60%
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           *
        service_description hdd
        check_command       check_disk
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}

    }
    define service {
        use                 generic-service
        host_name           *
        service_description users
        check_command       check_users
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}

    }
    define service {
        use                 generic-service
        host_name           *
        service_description processes
        check_command       check_procs
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           *
        service_description load
        check_command       check_load
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           *
        service_description memory
        check_command       check_mem
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           *
        service_description network traffic
        check_command       check_int
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           *
        service_description cpu temperature
        check_command       check_temp
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           *
        service_description uptime
        check_command       check_uptime
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           *
        service_description date
        check_command       check_date
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           *
        service_description ssh
        check_command       check_ssh
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - acme/apache
        check_command       check_k8s_acme
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - bigbrother/zoneminder
        check_command       check_k8s_bigbrother
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - filebrowser/apache
        check_command       check_k8s_filebrowser
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - kharon/expressvpn
        check_command       check_k8s_kharon_expressvpn
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - kharon/deluge
        check_command       check_k8s_kharon_deluge
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
    }
    define service {
        use                 generic-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - kharon/squid
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check_k8s_kharon_squid
    }
    define service {
        use                 generic-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - plex/plexserver
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check_k8s_plex_plexserver
    }
    define service {
        use                 generic-service
        host_name           kube00.labs.elysianskies.com
        service_description kubernetes service - plex/tautulli
        max_check_attempts  3
        check_interval      ${NAGIOS_CHECK_INTERVAL_MINUTES}
        retry_interval      ${NAGIOS_RETRY_INTERVAL_MINUTES}
        check_command       check_k8s_plex_tautulli
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
              mountPath: /opt/nagios/etc/objects/contacts.cfg
              subPath: contacts.cfg
            - name: nagios-config
              mountPath: /opt/nagios/etc/objects/commands.cfg
              subPath: commands.cfg
            - name: nagios-config
              mountPath: /opt/nagios/etc/conf.d/hosts.cfg
              subPath: hosts.cfg
            - name: nagios-config
              mountPath: /opt/nagios/etc/conf.d/services.cfg
              subPath: services.cfg
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
