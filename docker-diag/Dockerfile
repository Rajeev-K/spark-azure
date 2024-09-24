# A docker image suitable for use as diagnostic pod in k8s

FROM amd64/debian:latest

RUN apt-get update && apt-get install -y \
    bash \
    dnsutils \
    iputils-ping \
    curl \
    wget \
    net-tools \
    iproute2 \
    vim \
    telnet \
    tcpdump \
    traceroute \
    less \
    jq \
    htop \
    lsof \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
