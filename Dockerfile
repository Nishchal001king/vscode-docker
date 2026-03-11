FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl wget git sudo nano python3 python3-pip nodejs npm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN useradd -m -s /bin/bash coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER coder
WORKDIR /home/coder

RUN mkdir -p /home/coder/.config/code-server && \
    printf 'bind-addr: 0.0.0.0:8080\nauth: password\npassword: changeme123\ncert: false\n' \
    > /home/coder/.config/code-server/config.yaml

EXPOSE 8080
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/home/coder"]