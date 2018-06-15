# Run cron in a container to check torrents
#
# TO BUILD:
# docker build --build-arg VERSION=1.0.0 -t aauren/torrent_check:1.0.0 -t aauren/torrent_check:latest .
#
# TO RUN:
# docker run -d \
#   -v "/path/to/crontabs/dir:/var/spool/cron/crontabs"
#   -v "/path/to/dir/containing/any/scripts:/scripts"
#   aauren/torrent_check
#
# EXAMPLE:
# docker run -v "$(pwd)/cron.d:/var/spool/cron/crontabs" -v "$(pwd)/scripts:/scripts" \
#   aauren/torrent_check:latest

FROM lsiobase/alpine:3.7
MAINTAINER Aaron U'Ren <aauren@gmail.com>

ARG VERSION
LABEL build_version="version: ${VERSION}"
LABEL maintainer="aauren"

RUN echo "**** install build packages ****" \
  && apk add --no-cache --virtual=build-dependencies \
    curl \
    python \
    py-pip \
    perl \
    unrar \
    jq \
  && echo "**** install python packages ****" \
  && pip install \
    bencode \
    pyrocore \
  && echo "**** make directories and setup paths ****" \
  && mkdir -p /var/log/cron /scripts \
  && mkdir -m 0644 -p /var/spool/cron/crontabs \
  && touch /var/log/cron/cron.log \
  && echo "**** cleanup ****" \
  && rm -rf /tmp/*

# add local files from this repo
COPY root/ /
