#!/bin/bash

CURRENT_VERSION="1.0.6"

docker build -t aauren/stork:${CURRENT_VERSION} -t aauren/stork:latest .

docker push aauren/stork:${CURRENT_VERSION}
docker push aauren/stork:latest
