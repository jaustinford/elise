#!/usr/bin/env bash

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"

hostname="${HOST_HOSTNAME}"
uptime="$(uptime | awk '{print $3, $4}' | cut -d ',' -f1)"
date="$(date)"
install_date=$(rpm -qi basesystem | grep Install\ Date | cut -d":" -f2-4 | cut -d" " -f2-10)
cpu=$(lscpu | grep Model\ name | cut -d":" -f2 | egrep -o '[A-Za-z].*$')
total_memory=$(free | grep Mem | awk '{print $2}')
total_memory_human=$(free -h | grep Mem | awk '{print $2}')
free_memory=$(free | grep Mem | awk '{print $7}')
free_memory_percent=$(echo "$free_memory/$total_memory*100" | bc -l | egrep -o '[0-9]{2}[.][0-9]{2}')
root_partition_used=$(df -H | egrep '/root$' | awk '{print $5}')

echo -e \
"
  ${SHELL_USER_PROMPT_CODE}   docker host information                                                        ${ECHO_RESET}
   ---------------------------------------------------------------
  ${SHELL_HOST_PROMPT_CODE} hostname            ${ECHO_RESET} ${SHELL_CWD_PROMPT_CODE} $hostname             ${ECHO_RESET}
  ${SHELL_HOST_PROMPT_CODE} uptime              ${ECHO_RESET} ${SHELL_CWD_PROMPT_CODE} $uptime               ${ECHO_RESET}
  ${SHELL_HOST_PROMPT_CODE} date                ${ECHO_RESET} ${SHELL_CWD_PROMPT_CODE} $date                 ${ECHO_RESET}
  ${SHELL_HOST_PROMPT_CODE} install date        ${ECHO_RESET} ${SHELL_CWD_PROMPT_CODE} $install_date         ${ECHO_RESET}
  ${SHELL_HOST_PROMPT_CODE} cpu                 ${ECHO_RESET} ${SHELL_CWD_PROMPT_CODE} $cpu                  ${ECHO_RESET}
  ${SHELL_HOST_PROMPT_CODE} total memory        ${ECHO_RESET} ${SHELL_CWD_PROMPT_CODE} $total_memory_human   ${ECHO_RESET}
  ${SHELL_HOST_PROMPT_CODE} free memory         ${ECHO_RESET} ${SHELL_CWD_PROMPT_CODE} $free_memory_percent% ${ECHO_RESET}
  ${SHELL_HOST_PROMPT_CODE} root partition used ${ECHO_RESET} ${SHELL_CWD_PROMPT_CODE} $root_partition_used  ${ECHO_RESET}
"
