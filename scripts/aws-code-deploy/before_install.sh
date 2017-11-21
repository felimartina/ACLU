#!/bin/bash
set -x # echo bash commands before execution, useful for debugging
set -e # stop bash execution on on first error

# Install dockers on every deploy...so that we can update it from code without having to re-provision
# Install and configure docker
DOCKER_COMPOSE_VERSION=1.15.0
# used convenience scripts since this is just test
# https://docs.docker.com/engine/installation/linux/docker-ce/debian/#install-using-the-convenience-script
wget -qO- https://get.docker.com/ | sudo sh
# download docker-compose
# TODO - Add IF logic
sudo wget -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/run.sh
sudo chmod +x /usr/local/bin/docker-compose
# login to ECR ($ECR_REGION variable should have been setup by TF on deployment)
eval $(aws ecr get-login --region $ECR_REGION) 
#eval $(aws ecr get-login --no-include-email --region us-east-1) #=> DIDNT Find a good way of using env varibales for region...so lets harcode it for now
