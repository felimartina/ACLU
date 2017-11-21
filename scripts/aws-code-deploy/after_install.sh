#!/bin/bash
set -x # echo bash commands before execution, useful for debugging
set -e # stop bash execution on on first error

# Docker compose
cd /var/project-aclu/
sudo docker-compose down
sudo docker-compose up

# Create the spatial index
# TODO - Not sure if it is ok to run this on every deploy...is it idempotent?
# TODO2 - What about import scripts?
sudo docker exec $(docker ps -aqf "name=aclu-db") mongo aclu --eval "db.features.ensureIndex({'geojson.geometry': '2dsphere'})"
