#!/bin/bash

set -e

cp ../Dockerfile ../*.rb ./

IMAGE_ID=`docker build --quiet .`

# Not sure whether the -i or the -t are really needed.
docker run -it --rm -e "ORG=$ORG" -e "TOKEN=$TOKEN" $IMAGE_ID ruby _list.rb

rm Dockerfile config.rb
