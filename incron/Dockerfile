# Run incron in a container
#
# TO BUILD:
# docker build -t aauren/incron:1.0.0 -t aauren/incron:latest .
#
# TO RUN:
# docker run -d \
#   -v "/path/to/incron.d/dir:/etc/incron.d"
#   -v "/path/to/dir/containing/any/scripts:/scripts
#   -v "/path/to/any/directories/you/want/to/monitor:/path/configured/in/incrontab"
#   aauren/incron
#
# EXAMPLE:
# docker run -dv "$(pwd)/incron.d:/etc/incron.d" -v "$(pwd)/scripts:/scripts" \
#   -v "/tmp/watch_folder:/watches/tmp_watch" -v "/tmp/watch_output:/tmp/watch_output" \
#   aauren/incron:latest

FROM alpine:latest

RUN apk update \
  && apk add incron \
  && apk add curl \
  && apk add strace \
  && apk add bash

RUN mkdir -p /watches /scripts

CMD ["/usr/sbin/incrond", "-n"]
