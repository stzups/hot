#!/bin/bash

sudo apt update
sudo apt upgrade -y

# docker engine
# https://docs.docker.com/engine/install/ubuntu/
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

# docker compose
# https://docs.docker.com/compose/install/
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo docker-compose --version

# rootless docker (needed later)
sudo apt-get -y install uidmap

# user setup
sudo useradd -m -s /bin/bash docker-admin
# ensure systemd --user runs without requiring login
sudo loginctl enable-linger docker-admin
# todo this needs to be a real login (with ssh or something)
# su - (--login) is not enough to start systemd --user or something
# idk i don't know linux
sudo su - docker-admin

# rootless docker
# https://docs.docker.com/engine/security/rootless/#rootless-docker-in-docker
curl -fsSL https://get.docker.com/rootless | sh
#export PATH=/home/$(whoami)/bin:$PATH
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
systemctl --user start docker

docker version
docker-compose version
