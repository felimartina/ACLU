#!/bin/bash

# Docker compose
cd /var/project-aclu/
docker-compose down
docker-compose up

# Create the spatial index
# TODO - Not sure if it is ok to run this on every deploy...is it idempotent?
# TODO2 - What about import scripts?
docker exec $(docker ps -aqf "name=aclu-db") mongo aclu --eval "db.features.ensureIndex({'geojson.geometry': '2dsphere'})"
