#!/bin/bash
DOCKER_COMPOSE_VERSION=1.15.0

# install the dockers
sudo apt-get remove docker docker.io 2>/dev/null

# used convenience scripts since this is just test
# https://docs.docker.com/engine/installation/linux/docker-ce/debian/#install-using-the-convenience-script
wget -qO- https://get.docker.com/ | sudo sh

# download docker-compose
sudo wget -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/run.sh
sudo chmod +x /usr/local/bin/docker-compose