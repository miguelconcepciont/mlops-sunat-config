#!/bin/bash
REGISTRY=miguelsff
IMAGE_NAME=ray
TAG=2.47.1-py3116-sunat-v1

docker build -t $REGISTRY/$IMAGE_NAME:$TAG .
docker push $REGISTRY/$IMAGE_NAME:$TAG
