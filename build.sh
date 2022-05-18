#!/bin/bash

IMAGE=consul-maribor
TAG=latest

sudo docker login rg.fr-par.scw.cloud/djnd -u nologin -p $SCW_SECRET_TOKEN

# BUILD AND PUBLISH PRAVNA MREZA
sudo docker build -f Dockerfile -t $IMAGE:$TAG .
sudo docker tag $IMAGE:$TAG rg.fr-par.scw.cloud/djnd/$IMAGE:$TAG
sudo docker push rg.fr-par.scw.cloud/djnd/$IMAGE:$TAG
