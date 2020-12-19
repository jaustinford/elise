FROM centos:8
LABEL maintainer="Austin Ford <j.austin.ford@gmail.com>"

COPY entrypoint.sh /tmp/entrypoint.sh

RUN \
    yum update -y && \
    yum install -y \
        epel-release

RUN \
    yum install -y \
        tree \
        vim \
        curl \
        htop \
        bmon \
        wget \
        git \
        chrony \
        bc \
        nmap \
        net-tools \
        bind-utils

# python3
RUN \
    yum install -y python3 && \
    pip3 install --upgrade pip && \
    pip3 install \
        requests

# kubernetes client
RUN \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# youtube-dl
RUN \
    yum install -y youtube-dl && \
    dnf install -y dnf-plugins-core dnf-utils && \
    yum-config-manager -y --set-enabled powertools && \
    yum-config-manager -y --add-repo=https://negativo17.org/repos/epel-multimedia.repo && \
    dnf install -y ffmpeg

# source local profile
RUN \
    ln -s /root/.bash_profile /etc/profile.d/elise_shell.sh

RUN \
    chmod +x /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"]
