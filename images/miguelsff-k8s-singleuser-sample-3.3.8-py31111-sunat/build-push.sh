#!/bin/bash
REGISTRY=miguelsff
IMAGE_NAME=k8s-singleuser-sample
TAG=3.3.8-py31111-sunat

docker build -t $REGISTRY/$IMAGE_NAME:$TAG .
docker push $REGISTRY/$IMAGE_NAME:$TAG
