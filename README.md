## elise - eslabs wrapper shell and custom scripts
<br />

> **NOTE**: If you are using a Windows platform, clone project with Windows CRLF line endings
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

Export system variable with the location to the project directory
```
export ELISE_ROOT_DIR='/path/to/elise'
```

Ensure bash variables file exists with the following values assigned in it
<br />
`${ELISE_ROOT_DIR}/src/elise.sh` :
```
SHELL_USER_PROMPT_COLOR
SHELL_HOST_PROMPT_COLOR
SHELL_CWD_PROMPT_COLOR
SHELL_STDERR_COLOR
SHELL_STDOUT_COLOR
SHELL_KUBE_DISPLAY_BANNER_COLOR
SHELL_KUBE_DISPLAY_KEY_COLOR
GITHUB_COMMIT_USERNAME
GITHUB_COMMIT_EMAIL
GITHUB_DEFAULT_COMMIT_MESSAGE
GITHUB_DEFAULT_COMMIT_BRANCH
ISCSI_CHAP_SESSION_USERNAME
ISCSI_CHAP_SESSION_PASSWORD
ISCSI_CRON_HOST
ISCSI_PORTAL
ISCSI_LOCAL_MOUNT_DIR
ISCSI_BACKUP_DIR
ISCSI_IQN
ISCSI_BACKUP_VOLUMES
DOCKER_TIMEZONE
KUBE_CONFIG_FILE
KUBE_MANIFESTS_DIR
KHARON_EXPRESSVPN_SERVER
KHARON_EXPRESSVPN_USERNAME
KHARON_EXPRESSVPN_PASSWORD
KHARON_EXPRESSVPN_CERT
KHARON_EXPRESSVPN_KEY
KHARON_EXPRESSVPN_TLS
KHARON_EXPRESSVPN_CA
KHARON_DELUGE_DOWNLOAD_DIR
PLEX_CLAIM
PLEX_AFFINITY_NODE
LAB_FQDN
LAB_USER_AUSTIN_SSH_KEY
YOUDOWN_AUDIO_QUALITY
```

### deploy
---

Build and deploy docker container then drop into bash shell
```
${ELISE_ROOT_DIR}/scripts/container.sh deploy
```
