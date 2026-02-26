#!/bin/bash

CURRENT_VERSION="0.0.5"

docker build --pull --no-cache -t aauren/debug-toolbox:${CURRENT_VERSION} -t aauren/debug-toolbox:latest . || exit 1

docker push aauren/debug-toolbox:${CURRENT_VERSION} || exit 1
docker push aauren/debug-toolbox:latest || exit 1
