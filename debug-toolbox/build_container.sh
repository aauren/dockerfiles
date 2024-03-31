#!/bin/bash

docker build -t aauren/debug-toolbox:0.0.2 -t aauren/debug-toolbox:latest .

docker push aauren/debug-toolbox:0.0.2
docker push aauren/debug-toolbox:latest
