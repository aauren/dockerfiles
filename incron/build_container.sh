#!/bin/bash

CURRENT_VERSION="20261022"

docker build --pull --no-cache -t aauren/incron:${CURRENT_VERSION} -t aauren/incron:latest . || exit 1

docker push aauren/incron:${CURRENT_VERSION} || exit 1
docker push aauren/incron:latest || exit 1
