## elise - eslabs wrapper shell and custom scripts
<br />

> **NOTE** : if you are using a windows platform, clone project with windows crlf line endings
```
git clone git@github.com:jaustinford/elise.git --config core.autocrlf=input
```

<br />

### components
---

- ansible
- kubectl
- bash
- git
- youtube-dl
- certbot

<br />

### deploy
---

- export system variable with the location to the project directory
    ```
    export ELISE_ROOT_DIR='/path/to/this/project'
    ```

- ensure ansible-vault password file exists at `${ELISE_ROOT_DIR}/.vault.txt` with correct password inside

- deploy docker [container](https://github.com/jaustinford/elise/blob/main/scripts/container.sh) then drop into bash shell
    ```
    ${ELISE_ROOT_DIR}/scripts/container.sh deploy
    ${ELISE_ROOT_DIR}/scripts/container.sh shell
    ```

<br />

### variables
---

> **NOTE** : available color codes : `white`, `blue`, `green`, `cyan`, `red`, `purple`, `yellow`, `darkgray`, `lightgray`

> **NOTE** : assign `KHARON_EXPRESSVPN_SERVER` with one of the [expressvpn servers](https://github.com/jaustinford/elise/blob/main/files/expressvpn_servers.txt)

> **NOTE** : `base64` must be base64 encoded string

> **NOTE** : `_vars_encrypt` - command to re-encrypt vars file


`_vars_edit` :
| name                                       | type | default value                               | base64 |
|--------------------------------------------|------|---------------------------------------------|--------|
| **SHELL_USER_PROMPT_COLOR**                | str  |                                             |        |
| **SHELL_HOST_PROMPT_COLOR**                | str  |                                             |        |
| **SHELL_CWD_PROMPT_COLOR**                 | str  |                                             |        |
| **SHELL_STDOUT_COLOR**                     | str  | `${SHELL_USER_PROMPT_COLOR}`                |        |
| **SHELL_STDERR_COLOR**                     | str  | `red`                                       |        |
| **GITHUB_DEFAULT_COMMIT_MESSAGE**          | str  |                                             |        |
| **GITHUB_DEFAULT_COMMIT_BRANCH**           | str  | `main`                                      |        |
| **ISCSI_CHAP_SESSION_USERNAME**            | str  |                                             |        |
| **ISCSI_CHAP_SESSION_PASSWORD**            | str  |                                             |        |
| **ISCSI_PORTAL**                           | str  | `172.16.17.4`                               |        |
| **ISCSI_LOCAL_MOUNT_DIR**                  | str  | `/mnt/iscsi`                                |        |
| **ISCSI_BACKUP_DIR**                       | str  | `/mnt/tvault/es-labs/backups/iscsi_volumes` |        |
| **ISCSI_BACKUP_ROTATE_DAYS**               | str  | `30`                                        |        |
| **ISCSI_IQN**                              | str  | `iqn.2013-03.com.wdc:elysianskies`          |        |
| **ISCSI_BACKUP_VOLUMES**                   | list |                                             |        |
| **DOCKER_TIMEZONE**                        | str  | `America/Denver`                            |        |
| **KUBE_DISPLAY_BANNER**                    | str  |                                             |        |
| **KUBE_CONFIG_CERTIFICATE_AUTHORITY_DATA** | str  |                                             | `true` |
| **KUBE_CONFIG_CLIENT_CERTIFICATE_DATA**    | str  |                                             | `true` |
| **KUBE_CONFIG_CLIENT_KEY_DATA**            | str  |                                             | `true` |
| **KUBE_POD_NETWORK**                       | str  |                                             |        |
| **KUBE_NODEPORT_ACME**                     | str  |                                             |        |
| **KUBE_NODEPORT_INGRESS**                  | str  |                                             |        |
| **KUBE_NODEPORT_PLEXSERVER**               | str  | `32400`                                     |        |
| **KUBE_NODEPORT_SQUID**                    | str  |                                             |        |
| **KHARON_EXPRESSVPN_SERVER**               | str  | `usa-denver`                                |        |
| **KHARON_EXPRESSVPN_USERNAME**             | str  |                                             | `true` |
| **KHARON_EXPRESSVPN_PASSWORD**             | str  |                                             | `true` |
| **KHARON_EXPRESSVPN_CERT**                 | str  |                                             | `true` |
| **KHARON_EXPRESSVPN_KEY**                  | str  |                                             | `true` |
| **KHARON_EXPRESSVPN_TLS**                  | str  |                                             | `true` |
| **KHARON_EXPRESSVPN_CA**                   | str  |                                             | `true` |
| **KHARON_DELUGE_DOWNLOAD_DIR**             | str  | `/mnt/tvault/kharon`                        |        |
| **KHARON_DELUGE_MAX_ACTIVE_DOWNLOADING**   | str  | `3`                                         |        |
| **KHARON_DELUGE_PASSWORD**                 | str  |                                             |        |
| **PLEX_CLAIM**                             | str  |                                             |        |
| **LAB_FQDN**                               | str  | `labs.elysianskies.com`                     |        |
| **LAB_APACHE_MOTD**                        | str  |                                             |        |
| **LAB_USER_AUSTIN_SSH_KEY**                | str  |                                             | `true` |
| **LAB_SSL_DOMAINS**                        | list |                                             |        |
| **NAGIOS_USERNAME**                        | str  |                                             |        |
| **NAGIOS_PASSWORD**                        | str  |                                             |        |
| **NAGIOS_CHECK_INTERVAL_MINUTES**          | str  | `1`                                         |        |
| **NAGIOS_RETRY_INTERVAL_MINUTES**          | str  | `1`                                         |        |
| **NAGIOS_REFRESH_RATE_SECONDS**            | str  | `60`                                        |        |
| **NAGIOS_MAX_CHECK_ATTEMPTS**              | str  | `3`                                         |        |
| **WATCHER_USERNAME**                       | str  |                                             |        |
| **WATCHER_PASSWORD**                       | str  |                                             |        |
| **TVAULT_USERNAME**                        | str  |                                             |        |
| **TVAULT_PASSWORD**                        | str  |                                             |        |
| **HAPROXY_STATS_USERNAME**                 | str  |                                             |        |
| **HAPROXY_STATS_PASSWORD**                 | str  |                                             |        |
| **HAPROXY_STATS_URI**                      | str  | `/haproxy`                                  |        |
| **NTOPNG_LICENSE**                         | str  |                                             |        |

<br />

### resources
---

- [docker image](https://hub.docker.com/repository/docker/jamesaustin87/elise/general)
- [lab hardware](https://github.com/jaustinford/elise/blob/main/files/docs/hardware.md)
- [local dns resolutions](https://github.com/jaustinford/elise/blob/main/files/pihole/custom.list)
