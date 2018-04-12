#!/bin/bash

set -e

IMAGE_ID=`docker build --quiet .`
docker run -i --rm -e "ORG=$ORG" -e "TOKEN=$TOKEN" $IMAGE_ID ruby _subscribe.rb
