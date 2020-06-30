#!/bin/bash

docker build -t xinlc/jenkins-vue-build:10-node -f Dockerfile.build .
docker push xinlc/jenkins-vue-build:10-node