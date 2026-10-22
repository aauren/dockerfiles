#!/bin/bash

CURRENT_VERSION="20261022"

docker build --pull --no-cache -t aauren/netcat:${CURRENT_VERSION} -t aauren/netcat:latest . || exit 1

docker push aauren/netcat:${CURRENT_VERSION} || exit 1
docker push aauren/netcat:latest || exit 1
