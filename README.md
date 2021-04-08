# elise
Bash Wrapper for managing Kubernetes on Elysian Skies

### kubernetes services
---

- [haproxy stats](https://labs.elysianskies.com/haproxy)
- [plex server](https://plex.tv/web)
- [nagios host monitoring](https://labs.elysianskies.com/nagios/)
- [tvault filebrowser](https://labs.elysianskies.com/tvault)
- [ntopng traffic monitor](https://labs.elysianskies.com/ntopng)
- [pihole console](https://labs.elysianskies.com/pihole/admin/)
- [tautulli plex monitor](https://labs.elysianskies.com/tautulli/)
- [hyperion home security](https://labs.elysianskies.com/zm/)
- [deluge web torrent server](https://labs.elysianskies.com/deluge)

### git
---

> **NOTE** : if you are using a windows platform, clone project with windows crlf line endings
```
git clone git@github.com:jaustinford/elise.git --config core.autocrlf=input
```

<br />

### deploy
---

- export system variable with the location to the project directory
    ```
    export ELISE_ROOT_DIR='/path/to/this/project'
    ```

- ensure ansible-vault password file exists at `${ELISE_ROOT_DIR}/.vault.txt` with correct password inside

- deploy docker [container](https://github.com/jaustinford/elise/blob/main/scripts/container.sh)
    ```
    ${ELISE_ROOT_DIR}/scripts/container.sh deploy
    ```

- the shell can be accessed in one of two modes: `shell-min` will execute just the functions needed to get to the shell and `shell-full` does all that plus prints motd and runs a series of connectivity checks against the kubernetes api server
    ```
    ${ELISE_ROOT_DIR}/scripts/container.sh shell-full
    ```
    ```
    ${ELISE_ROOT_DIR}/scripts/container.sh shell-min
    ```

<br />

### variables
---

variables are stored in [`${ELISE_ROOT_DIR}/src/elise.sh`](https://github.com/jaustinford/elise/blob/main/src/elise.sh) as an encrypted ansible-vault file

deploying container attempts to decrypt this file and will fail the container if it can't

once decrypted, the values can be retrieved in bash via the alias : `_vars_edit`

> **NOTE** : color values must match a value specified in this [`BASH_COLORS`](https://github.com/jaustinford/elise/blob/main/src/general.sh#L7) array

> **NOTE** : assign `KHARON_EXPRESSVPN_SERVER` with one of the [expressvpn servers](https://github.com/jaustinford/elise/blob/main/files/expressvpn_servers.txt)

> **NOTE** : `base64` must be base64 encoded string

| name                                       | type | default value                               | base64 |
|--------------------------------------------|------|---------------------------------------------|--------|
| **SHELL_FORMAT_TYPE**                      | str  | `normal`                                    |        |
| **SHELL_USER_PROMPT_COLOR**                | str  | `lightgreen`                                |        |
| **SHELL_HIST_PROMPT_COLOR**                | str  | `gray`                                      |        |
| **SHELL_HOST_PROMPT_COLOR**                | str  | `white`                                     |        |
| **SHELL_CWD_PROMPT_COLOR**                 | str  | `gray`                                      |        |
| **SHELL_STDOUT_COLOR**                     | str  | `${SHELL_USER_PROMPT_COLOR}`                |        |
| **SHELL_STDERR_COLOR**                     | str  | `red`                                       |        |
| **SHELL_KUBE_DISPLAY_BANNER_COLOR**        | str  | `${SHELL_CWD_PROMPT_COLOR}`                 |        |
| **SHELL_KUBE_DISPLAY_KEY_COLOR**           | str  | `${SHELL_USER_PROMPT_COLOR}`                |        |
| **GITHUB_DEFAULT_COMMIT_MESSAGE**          | str  | `automated debugging commit`                |        |
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
| **KUBE_POD_NETWORK**                       | str  | `10.244.0.0/16`                             |        |
| **KUBE_NODEPORT_HERMES**                   | str  | `32565`                                     |        |
| **KUBE_NODEPORT_INGRESS**                  | str  | `32566`                                     |        |
| **KUBE_NODEPORT_PLEXSERVER**               | str  | `32400`                                     |        |
| **KUBE_NODEPORT_SQUID**                    | str  | `32566`                                     |        |
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

### docker
---

- [docker hub image](https://hub.docker.com/repository/docker/jamesaustin87/elise/general)
- [Dockerfile](https://github.com/jaustinford/elise/blob/docker/Dockerfile)

<br />

### resources
---

- [lab hardware](https://github.com/jaustinford/elise/blob/main/files/docs/hardware.md)
- [coding conventions and style guide](https://github.com/jaustinford/elise/blob/main/files/docs/conventions.md)
- [local dns resolutions](https://github.com/jaustinford/elise/blob/main/files/pihole/custom.list)
