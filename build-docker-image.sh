#!/bin/bash
set -e
DOCKER_IMAGE=opentripplanner-data-container

# Set these environment variables
ORG=
DOCKER_TAG=latest
DOCKER_EMAIL=
DOCKER_USER=
DOCKER_AUTH=

# Build image
docker build --tag="$ORG/$DOCKER_IMAGE:builder" -f Dockerfile.builder .
mkdir target
docker run --rm --entrypoint tar $ORG/opentripplanner-data-container:builder -c /opt/opentripplanner-data-container/webroot|tar x -C target 
docker build --tag="$ORG/$DOCKER_IMAGE:$DOCKER_TAG" -f Dockerfile .
docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_AUTH
docker push $ORG/$DOCKER_IMAGE:$DOCKER_TAG
docker tag $ORG/$DOCKER_IMAGE:$DOCKER_TAG $ORG/$DOCKER_IMAGE:latest
docker push $ORG/$DOCKER_IMAGE:latest

rm -rf target
