#!/usr/bin/env bash

set -e

. "${SHELL_ROOT_DIR}/src/eslabs.env"
. "${SHELL_ROOT_DIR}/src/colors.sh"

# lab activity switch
if [ -z "$(docker ps)" ]; then
    active_light="${ECHO_RED}"
    active="OFF"

else
    active_light="${ECHO_GREEN}"
    active="ON"

fi

# centos vs. raspbian
operating_system="$(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | sed 's/"//g')"
if [ "${operating_system}" == "Raspbian GNU/Linux 10 (buster)" ]; then
    install_date=""
    interface='eth0'
    rx=$(ifconfig ${interface} | grep RX\ packets | cut -d'(' -f2 | cut -d')' -f1)
    tx=$(ifconfig ${interface} | grep TX\ packets | cut -d'(' -f2 | cut -d')' -f1)

elif [ "${operating_system}" == "CentOS Linux 8 (Core)" ]; then
    install_date=$(rpm -qi basesystem | grep Install\ Date | cut -d":" -f2-4 | cut -d" " -f2-10)
    interface='bond0'
    rx=$(ifconfig ${interface} | grep RX\ packets | cut -d'(' -f2 | cut -d')' -f1)
    tx=$(ifconfig ${interface} | grep TX\ packets | cut -d'(' -f2 | cut -d')' -f1)

fi

if [ -z "$(docker ps | grep apiserver)" ]; then
    node_role='worker'

else
    node_role='master'

fi

# user information
user=$(echo $USER)
client_ip=$(echo $SSH_CONNECTION | awk '{print $1}')
if [ ! -z "$client_ip" ]; then
    dns_name=$(host $client_ip | awk '{print $5}' | sed -E 's/[.]$//g')

fi
shell=$(echo $SHELL)
ssh_tty=$(echo $SSH_TTY)
user_home=$(echo $HOME)
last_login=$(last | grep -v logged\ in | head -1 | egrep -o '[A-Z].*$')

# system information
hostname="$(hostname)"
host_ip="$(hostname -i | egrep -o '172.16.17.[0-9]{1,}')"
uptime="$(uptime | awk '{print $3, $4}' | cut -d ',' -f1)"
timezone=$(timedatectl | grep Time\ zone | awk '{print $3}')
date="$(date)"
install_date="${install_date}"
operating_system="${operating_system}"
cpu=$(lscpu | grep Model\ name | cut -d":" -f2 | egrep -o '[A-Za-z].*$')
total_memory=$(free | grep Mem | awk '{print $2}')
total_memory_human=$(free -h | grep Mem | awk '{print $2}')
free_memory=$(free | grep Mem | awk '{print $7}')
free_memory_percent=$(echo "$free_memory/$total_memory*100" | bc -l | egrep -o '[0-9]{2}[.][0-9]{2}')
root_partition_used=$(df -H | egrep '/$' | awk '{print $5}')
rx="${rx}"
tx="${tx}"

# kubernetes
docker_version=$(docker version | grep ^\ Version\: | awk '{print $2}')
kubernetes_version=$(kubeadm version | awk '{print $5}' | cut -d':' -f2 | sed -E 's/("|,)//g' | head -1)
node_role="${node_role}"
running_containers=$(docker ps -q 2> /dev/null | wc -l)
total_containers=$(docker ps -a -q 2> /dev/null | wc -l)
total_images=$(docker images -a -q 2> /dev/null | wc -l)

# tvault volume
if [ -z "$(df -H | egrep \/\/172.16.17.4\/tvault)" ]; then
    tvault_server=$(host tvault.labs.elysianskies.com | awk '{print $4}')
    tvault_state="tvault not mounted"
    tvault_proto=''
    tvault_size=''
    tvault_used=''
    tvault_avail=''
    tvault_percent=''

else
    tvault_server=$(host tvault.labs.elysianskies.com | awk '{print $4}')
    tvault_state="mounted on $(df -H | egrep \/\/172.16.17.4\/tvault | awk '{print $6}')"
    tvault_proto='samba'
    tvault_size=$(df -H | egrep \/\/172.16.17.4\/tvault | awk '{print $2}')
    tvault_used=$(df -H | egrep \/\/172.16.17.4\/tvault | awk '{print $3}')
    tvault_avail=$(df -H | egrep \/\/172.16.17.4\/tvault | awk '{print $4}')
    tvault_percent="($(df -H | egrep \/\/172.16.17.4\/tvault | awk '{print $5}'))"

fi

clear

echo -e \
  "
  -----------------------------------------------------------

 ${SHELL_HOST_PROMPT_CODE}                cluster $ECHO_RESET : $active_light $active                                    $ECHO_RESET

 ${SHELL_USER_PROMPT_CODE}   user information                                                                            $ECHO_RESET
  -----------------------------------------------------------
 ${SHELL_HOST_PROMPT_CODE} user                   $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $user                                   $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} client ip              $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $client_ip => ($dns_name)               $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} shell                  $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $shell                                  $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} ssh tty                $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $ssh_tty                                $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} user home              $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $user_home                              $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} last login             $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $last_login                             $ECHO_RESET
 
 ${SHELL_USER_PROMPT_CODE}   system information                                                                          $ECHO_RESET
  -----------------------------------------------------------
 ${SHELL_HOST_PROMPT_CODE} hostname               $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $hostname                               $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} host ip                $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $host_ip                                $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} uptime                 $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $uptime                                 $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} timezone               $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $timezone                               $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} date                   $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $date                                   $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} install date           $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $install_date                           $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} operating system       $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $operating_system                       $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} cpu                    $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $cpu                                    $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} total memory           $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $total_memory_human                     $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} free memory            $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $free_memory_percent%                   $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} root partition used    $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $root_partition_used                    $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} bond0 rx               $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $rx                                     $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} bond0 tx               $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $tx                                     $ECHO_RESET
 
 ${SHELL_USER_PROMPT_CODE}   kubernetes                                                                                  $ECHO_RESET
  -----------------------------------------------------------
 ${SHELL_HOST_PROMPT_CODE} docker version         $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $docker_version                         $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} kubernetes version     $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $kubernetes_version                     $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} node role              $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $node_role                              $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} running containers     $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $running_containers                     $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} total containers       $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $total_containers                       $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} total images           $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $total_images                           $ECHO_RESET

 ${SHELL_USER_PROMPT_CODE}   tvault volume                                                                               $ECHO_RESET
  -----------------------------------------------------------
 ${SHELL_HOST_PROMPT_CODE} tvault server          $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $tvault_server                          $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} tvault state           $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $tvault_state                           $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} tvault proto           $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $tvault_proto                           $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} tvault size            $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $tvault_size                            $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} tvault used            $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $tvault_used $tvault_percent            $ECHO_RESET
 ${SHELL_HOST_PROMPT_CODE} tvault avail           $ECHO_RESET : ${SHELL_CWD_PROMPT_CODE} $tvault_avail                           $ECHO_RESET

"
