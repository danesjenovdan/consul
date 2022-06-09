#!/bin/bash

TAG=latest

sudo docker login rg.fr-par.scw.cloud/djnd -u nologin -p $SCW_SECRET_TOKEN

# BUILD AND PUBLISH PRAVNA MREZA
sudo docker build -f Dockerfile -t consul-koper:$TAG .
sudo docker tag consul-koper:$TAG rg.fr-par.scw.cloud/djnd/consul-koper:$TAG
sudo docker push rg.fr-par.scw.cloud/djnd/consul-koper:$TAG
