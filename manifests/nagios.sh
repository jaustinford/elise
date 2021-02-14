#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"

NAGIOS_CREDENTIALS=$(htpasswd -n -b "${NAGIOS_USER}" "${NAGIOS_PASSWORD}")

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
  htpasswd.users:
    ${NAGIOS_CREDENTIALS}
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
    refresh_rate=90
    result_limit=100
    escape_html_tags=1
    action_url_target=_self
    notes_url_target=_self
    lock_author_names=1
  nagios.cfg: |
    log_file=/opt/nagios/var/nagios.log
    cfg_file=/opt/nagios/etc/objects/commands.cfg
    cfg_file=/opt/nagios/etc/objects/contacts.cfg
    cfg_file=/opt/nagios/etc/objects/timeperiods.cfg
    cfg_file=/opt/nagios/etc/objects/templates.cfg
    cfg_file=/opt/nagios/etc/objects/localhost.cfg
    object_cache_file=/opt/nagios/var/objects.cache
    precached_object_file=/opt/nagios/var/objects.precache
    resource_file=/opt/nagios/etc/resource.cfg
    status_file=/opt/nagios/var/status.dat
    status_update_interval=10
    nagios_user=nagios
    nagios_group=nagios
    check_external_commands=1
    command_file=/opt/nagios/var/rw/nagios.cmd
    lock_file=/opt/nagios/var/nagios.lock
    temp_file=/opt/nagios/var/nagios.tmp
    temp_path=/tmp
    event_broker_options=-1
    log_rotation_method=d
    log_archive_path=/opt/nagios/var/archives
    use_syslog=1
    log_notifications=1
    log_service_retries=1
    log_host_retries=1
    log_event_handlers=1
    log_initial_states=0
    log_current_states=1
    log_external_commands=1
    log_passive_checks=1
    service_inter_check_delay_method=s
    max_service_check_spread=30
    service_interleave_factor=s
    host_inter_check_delay_method=s
    max_host_check_spread=30
    max_concurrent_checks=0
    check_result_reaper_frequency=10
    max_check_result_reaper_time=30
    check_result_path=/opt/nagios/var/spool/checkresults
    max_check_result_file_age=3600
    cached_host_check_horizon=15
    cached_service_check_horizon=15
    enable_predictive_host_dependency_checks=1
    enable_predictive_service_dependency_checks=1
    soft_state_dependencies=0
    auto_reschedule_checks=0
    auto_rescheduling_interval=30
    auto_rescheduling_window=180
    service_check_timeout=60
    host_check_timeout=30
    event_handler_timeout=30
    notification_timeout=30
    ocsp_timeout=5
    perfdata_timeout=5
    retain_state_information=1
    state_retention_file=/opt/nagios/var/retention.dat
    retention_update_interval=60
    use_retained_program_state=1
    use_retained_scheduling_info=1
    retained_host_attribute_mask=0
    retained_service_attribute_mask=0
    retained_process_host_attribute_mask=0
    retained_process_service_attribute_mask=0
    retained_contact_host_attribute_mask=0
    retained_contact_service_attribute_mask=0
    interval_length=60
    check_for_updates=1
    bare_update_check=0
    use_aggressive_host_checking=0
    execute_service_checks=1
    accept_passive_service_checks=1
    execute_host_checks=1
    accept_passive_host_checks=1
    enable_notifications=1
    enable_event_handlers=1
    process_performance_data=1
    service_perfdata_file=/opt/nagios/var/perfdata.log
    host_perfdata_file_template=empty
    service_perfdata_file_template=\$LASTSERVICECHECK\$||\$HOSTNAME\$||\$SERVICEDESC\$||\$SERVICEOUTPUT\$||\$SERVICEPERFDATA\$
    host_perfdata_file_mode=w
    service_perfdata_file_mode=a
    service_perfdata_file_processing_interval=10
    service_perfdata_file_processing_command=process-service-perfdata
    obsess_over_services=0
    obsess_over_hosts=0
    translate_passive_host_checks=0
    passive_host_checks_are_soft=0
    check_for_orphaned_services=1
    check_for_orphaned_hosts=1
    check_service_freshness=1
    service_freshness_check_interval=60
    service_check_timeout_state=c
    check_host_freshness=0
    host_freshness_check_interval=60
    additional_freshness_latency=15
    enable_flap_detection=1
    low_service_flap_threshold=5.0
    high_service_flap_threshold=20.0
    low_host_flap_threshold=5.0
    high_host_flap_threshold=20.0
    date_format=us
    illegal_object_name_chars=\`~!\$%^&*|'"<>?,()=
    illegal_macro_output_chars=\`~\$&|'"<>
    use_regexp_matching=0
    use_true_regexp_matching=0
    admin_email=nagios@localhost
    admin_pager=pagenagios@localhost
    daemon_dumps_core=0
    use_large_installation_tweaks=0
    enable_environment_macros=0
    debug_level=256
    debug_verbosity=1
    debug_file=/opt/nagios/var/nagios.debug
    max_debug_file_size=1000000
    allow_empty_hostgroup_assignment=0
    cfg_dir=/opt/nagios/etc/conf.d
    cfg_dir=/opt/nagios/etc/monitor
    cfg_dir=/opt/nagios/etc/servers
    use_timezone=UTC
  resource.cfg: |
    \$USER1\$=/opt/nagios/libexec
  contacts.cfg: |
    define contact {
        contact_name            ${NAGIOS_USER}
        use                     generic-contact
        alias                   Nagios Admin
        email                   j.austin.ford@gmail.com
    }
    define contactgroup {
        contactgroup_name       admins
        alias                   Nagios Administrators
        members                 ${NAGIOS_USER}
    }
  commands.cfg: |
    define command {
        command_name    check_nrpe
        command_line    \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c \$ARG1\$ \$ARG2\$
    }
    define command {
        command_name    notify-host-by-email
        command_line    /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: \$NOTIFICATIONTYPE\$\nHost: \$HOSTNAME\$\nState: \$HOSTSTATE\$\nAddress: \$HOSTADDRESS\$\nInfo: \$HOSTOUTPUT\$\n\nDate/Time: \$LONGDATETIME\$\n" | /usr/bin/mail -s "** \$NOTIFICATIONTYPE\$ Host Alert: \$HOSTNAME\$ is \$HOSTSTATE\$ **" \$CONTACTEMAIL\$
    }
    define command {
        command_name    notify-service-by-email
        command_line    /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: \$NOTIFICATIONTYPE\$\n\nService: \$SERVICEDESC\$\nHost: \$HOSTALIAS\$\nAddress: \$HOSTADDRESS\$\nState: \$SERVICESTATE\$\n\nDate/Time: \$LONGDATETIME\$\n\nAdditional Info:\n\n\$SERVICEOUTPUT\$\n" | /usr/bin/mail -s "** \$NOTIFICATIONTYPE\$ Service Alert: \$HOSTALIAS\$/\$SERVICEDESC\$ is \$SERVICESTATE\$ **" \$CONTACTEMAIL\$
    }
    define command {
        command_name    check-host-alive
        command_line    \$USER1\$/check_ping -H \$HOSTADDRESS\$ -w 3000.0,80% -c 5000.0,100% -p 5
    }
    define command {
        command_name    check_local_disk
        command_line    \$USER1\$/check_disk -w \$ARG1\$ -c \$ARG2\$ -p \$ARG3\$
    }
    define command {
        command_name    check_local_load
        command_line    \$USER1\$/check_load -w \$ARG1\$ -c \$ARG2\$
    }
    define command {
        command_name    check_local_procs
        command_line    \$USER1\$/check_procs -w \$ARG1\$ -c \$ARG2\$ -s \$ARG3\$
    }
    define command {
        command_name    check_local_users
        command_line    \$USER1\$/check_users -w \$ARG1\$ -c \$ARG2\$
    }
    define command {
        command_name    check_local_swap
        command_line    \$USER1\$/check_swap -w \$ARG1\$ -c \$ARG2\$
    }
    define command {
        command_name    check_http
        command_line    \$USER1\$/check_http -I \$HOSTADDRESS\$ \$ARG1\$
    }
    define command {
        command_name    check_ssh
        command_line    \$USER1\$/check_ssh \$ARG1\$ \$HOSTADDRESS\$
    }
    define command {
        command_name    check_ping
        command_line    \$USER1\$/check_ping -H \$HOSTADDRESS\$ -w \$ARG1\$ -c \$ARG2\$ -p 5
    }
    define command {
        command_name    check_tcp
        command_line    \$USER1\$/check_tcp -H \$HOSTADDRESS\$ -p \$ARG1\$ \$ARG2\$
    }
    define command {
        command_name    check_udp
        command_line    \$USER1\$/check_udp -H \$HOSTADDRESS\$ -p \$ARG1\$ \$ARG2\$
    }
    define command {
        command_name    process-service-perfdata
        command_line    /opt/nagiosgraph/bin/insert.pl
    }
  servers.cfg: |
    define host {
      host_name          kube00.labs.elysianskies.com
      alias              kube00.labs.elysianskies.com
      display_name       kube00.labs.elysianskies.com
      address            172.16.17.20
      contacts           ${NAGIOS_USER}
      max_check_attempts 3
      check_interval     ${NAGIOS_CHECK_INTERVAL}
      retry_interval     30
      check_command      check-host-alive
    }
    define host {
      host_name          kube01.labs.elysianskies.com
      alias              kube01.labs.elysianskies.com
      display_name       kube01.labs.elysianskies.com
      address            172.16.17.6
      contacts           ${NAGIOS_USER}
      max_check_attempts 3
      check_interval     ${NAGIOS_CHECK_INTERVAL}
      retry_interval     30
      check_command      check-host-alive
    }
    define host {
      host_name          kube02.labs.elysianskies.com
      alias              kube02.labs.elysianskies.com
      display_name       kube02.labs.elysianskies.com
      address            172.16.17.7
      contacts           ${NAGIOS_USER}
      max_check_attempts 3
      check_interval     ${NAGIOS_CHECK_INTERVAL}
      retry_interval     30
      check_command      check-host-alive
    }
    define host {
      host_name          dns.labs.elysianskies.com
      alias              dns.labs.elysianskies.com
      display_name       dns.labs.elysianskies.com
      address            172.16.17.10
      contacts           ${NAGIOS_USER}
      max_check_attempts 3
      check_interval     ${NAGIOS_CHECK_INTERVAL}
      retry_interval     30
      check_command      check-host-alive
    }
    define host {
      host_name          netmon.labs.elysianskies.com
      alias              netmon.labs.elysianskies.com
      display_name       netmon.labs.elysianskies.com
      address            172.16.17.19
      contacts           ${NAGIOS_USER}
      max_check_attempts 3
      check_interval     ${NAGIOS_CHECK_INTERVAL}
      retry_interval     30
      check_command      check-host-alive
    }
    define host {
      host_name          watcher01.labs.elysianskies.com
      alias              watcher01.labs.elysianskies.com
      display_name       watcher01.labs.elysianskies.com
      address            172.16.17.13
      contacts           ${NAGIOS_USER}
      max_check_attempts 3
      check_interval     ${NAGIOS_CHECK_INTERVAL}
      retry_interval     30
      check_command      check-host-alive
    }
    define host {
      host_name          watcher02.labs.elysianskies.com
      alias              watcher02.labs.elysianskies.com
      display_name       watcher02.labs.elysianskies.com
      address            172.16.17.14
      contacts           ${NAGIOS_USER}
      max_check_attempts 3
      check_interval     ${NAGIOS_CHECK_INTERVAL}
      retry_interval     30
      check_command      check-host-alive
    }
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
              mountPath: /opt/nagios/etc/cgi.cfg
              subPath: cgi.cfg
            - name: nagios-config
              mountPath: /opt/nagios/etc/nagios.cfg
              subPath: nagios.cfg
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
              mountPath: /opt/nagios/etc/servers/servers.cfg
              subPath: servers.cfg
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
