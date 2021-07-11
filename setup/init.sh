#!/bin/bash

#
# System
#

sudo apt-get update
sudo apt-get -y upgrade

#
# Docker Engine
# https://docs.docker.com/engine/install/ubuntu/
#

sudo apt-get update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

sudo docker version

#
# Docker Compose
# https://docs.docker.com/compose/install/
#

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo docker-compose --version

#
# Rootless Docker
# https://docs.docker.com/engine/security/rootless/
#

sudo apt-get -y install uidmap

# user setup
sudo useradd -m -s /bin/bash docker-user
# ensure systemd --user runs without requiring login
sudo loginctl enable-linger docker-user
sudo su - docker-user << EOF



# https://unix.stackexchange.com/a/657714/480971 :)
export XDG_RUNTIME_DIR=/run/user/$UID
curl -fsSL https://get.docker.com/rootless | sh
#export PATH=/home/$(whoami)/bin:$PATH #optional?
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
systemctl --user start docker

docker version
docker-compose version

EOF