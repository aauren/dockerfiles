#!/bin/bash

CURRENT_VERSION="1.1.1"

docker build --pull --no-cache -t aauren/stork:${CURRENT_VERSION} -t aauren/stork:latest .

docker push aauren/stork:${CURRENT_VERSION}
docker push aauren/stork:latest
