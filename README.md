## elise - eslabs wrapper shell and custom scripts
<br />

> **NOTE**: if you are using a Windows platform, clone project with Windows CRLF line endings
```
git clone git@github.com:jaustinford/elise.git --config core.autocrlf=input
```

### components
---

- ansible
- kubectl
- bash
- git
- youtube-dl
- certbot

### variables
---

- export system variable with the location to the project directory
```
export ELISE_ROOT_DIR='/path/to/this/project'
```

- ensure bash variables file exists with the following values assigned in it

`${ELISE_ROOT_DIR}/src/elise.sh` :
> **NOTE**: available *_COLOR options : `white`, `blue`, `green`, `cyan`, `red`, `purple`, `yellow`, `darkgray`, `lightgray`

| name                          | type | default value                  | base64 |
|-------------------------------|------|--------------------------------| -------|
| SHELL_USER_PROMPT_COLOR       | str  |                                |        |
| SHELL_HOST_PROMPT_COLOR       | str  |                                |        |
| SHELL_CWD_PROMPT_COLOR        | str  |                                |        |
| SHELL_STDERR_COLOR            | str  | `green`                        |        |
| SHELL_STDOUT_COLOR            | str  | `red`                          |        |
| GITHUB_DEFAULT_COMMIT_MESSAGE | str  |                                |        |
| GITHUB_DEFAULT_COMMIT_BRANCH  | str  | `main`                         |        |
| ISCSI_CHAP_SESSION_USERNAME   | str  |                                |        |
| ISCSI_CHAP_SESSION_PASSWORD   | str  |                                |        |
| ISCSI_CRON_HOST               | str  | `kube02.labs.elysianskies.com` |        |
| ISCSI_PORTAL                  | str  |                                |        |
| ISCSI_LOCAL_MOUNT_DIR         | str  | `/mnt/iscsi`                   |        |
| ISCSI_BACKUP_DIR              | str  |                                |        |
| ISCSI_IQN                     | str  |                                |        |
| ISCSI_BACKUP_VOLUMES          | list |                                |        |
| DOCKER_TIMEZONE               | str  | `America/Denver`               |        |
| KUBE_CONFIG_FILE              | str  |                                |        |
| KUBE_MANIFESTS_DIR            | str  | `${ELISE_ROOT_DIR}/manifests`  |        |
| KHARON_EXPRESSVPN_SERVER      | str  | `usa-denver`                   |        |
| KHARON_EXPRESSVPN_USERNAME    | str  |                                | `true` |
| KHARON_EXPRESSVPN_PASSWORD    | str  |                                | `true` |
| KHARON_EXPRESSVPN_CERT        | str  |                                | `true` |
| KHARON_EXPRESSVPN_KEY         | str  |                                | `true` |
| KHARON_EXPRESSVPN_TLS         | str  |                                | `true` |
| KHARON_EXPRESSVPN_CA          | str  |                                | `true` |
| KHARON_DELUGE_DOWNLOAD_DIR    | str  | `/mnt/tvault/kharon`           |        |
| PLEX_CLAIM                    | str  |                                |        |
| PLEX_AFFINITY_NODE            | str  | `kube01.labs.elysianskies.com` |        |
| LAB_FQDN                      | str  | `labs.elysianskies.com`        |        |
| LAB_USER_AUSTIN_SSH_KEY       | str  |                                | `true` |
| YOUDOWN_AUDIO_QUALITY         | str  | `320`                          |        |


### deploy
---

- build and deploy docker [container](https://github.com/jaustinford/elise/blob/main/scripts/container.sh) then drop into bash shell
```
${ELISE_ROOT_DIR}/scripts/container.sh deploy
```
