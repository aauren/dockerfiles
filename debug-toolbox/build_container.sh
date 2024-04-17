#!/bin/bash

CURRENT_VERSION="0.0.3"

docker build -t aauren/debug-toolbox:${CURRENT_VERSION} -t aauren/debug-toolbox:latest .

docker push aauren/debug-toolbox:${CURRENT_VERSION}
docker push aauren/debug-toolbox:latest
