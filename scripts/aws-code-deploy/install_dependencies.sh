#!/bin/bash
set -x # echo bash commands before execution, useful for debugging
set -e # stop bash execution on on first error

NODE_VERSION=8.1.4 # latest Node version as of 15-Aug-2017
JQ_VERSION=1.5 # latest jq version as of 15-Aug-2015


sudo apt-get update
sudo apt-get install -y \
     python-pip \
     git \
     httpie \
     gdal-bin


# install ./jq (https://stedolan.github.io/jq/)
sudo wget -O /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64
sudo chmod a+x /usr/local/bin/jq

# nuke any previous versions of node in /usr/local/node
sudo rm -rf /usr/local/node-*-linux-x64 /usr/local/node

# donwnload and unpack node into /usr/local
cd /usr/local
wget -qO- https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz | sudo tar xvJ
sudo ln -s /usr/local/node-v${NODE_VERSION}-linux-x64 /usr/local/node

# add /usr/local/node to user's path
# echo "export PATH=/usr/local/node/bin/:${PATH}" >> ${HOME}/.profile
export PATH=/usr/local/node/bin/:${PATH}

# install yarn
sudo env "PATH=/usr/local/node/bin/:${PATH}" npm install -g yarn@"0.27.5"
