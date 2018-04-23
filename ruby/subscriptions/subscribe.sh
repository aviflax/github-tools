#!/bin/bash

set -e

cp ../Dockerfile ../*.rb ./

IMAGE_ID=`docker build --quiet .`

# The -i is required for the progress bar to work
docker run -i --rm -e "ORG=$ORG" -e "TOKEN=$TOKEN" $IMAGE_ID ruby _subscribe.rb $1

rm Dockerfile config.rb
