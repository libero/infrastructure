#!/bin/bash
set -e

sudo apt-get update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    git \
    jq

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
sudo apt-get update
sudo apt-get install -y docker-ce

# docker-compose
wget -O /tmp/docker-compose https://github.com/docker/compose/releases/download/1.21.2/docker-compose-Linux-x86_64
chmod +x /tmp/docker-compose
sudo mv /tmp/docker-compose /usr/local/bin/docker-compose

# ubuntu user
sudo usermod -a -G docker ubuntu
