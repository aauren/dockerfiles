# Run Rainlendar in a container
#
# mkdir -p ${HOME}/.rainlendar2
# RHOME="/home/rainlendar"
# docker run \
#   --net=host \ # needed to actually be able to use the X display
#   --cpuset-cpus 0 \ # set maximum number of CPUS
#   --memory 128mb \ # set maximum amount of memory it can use
#   --device /dev/snd \ # So it can use the sound card to notify
#   -v "${HOME}/.Xauthority:${RHOME}/.Xauthority:ro" \ # Needed so it has access to the Xdisplay
#   -v "${HOME}/.rainlendar2:${RHOME}/.rainlendar2" \ # Needed so we don't lose our settings
#   -v "/etc/localtime:/etc/localtime:ro" \ # Needed so that the user's timezone is picked up
#   -e DISPLAY=unix${DISPLAY} \
#   rainlendar-ubuntu

FROM ubuntu
MAINTAINER Aaron U'Ren <aauren@gmail.com>

ADD http://www.rainlendar.net/download/b159/rainlendar2-pro_2.14.3.b159-1_amd64.deb /src/rainlendar2.deb

RUN echo "==== Updating apt-get ====" && apt-get update \
  && echo "==== Running apt-get install for rainlendar dependencies ====" \
  && apt-get install -qqy libcurl3 libatk1.0-0 libcairo2 libfontconfig1 libfreetype6 libglib2.0-0 libgtk2.0-0 \
     libpango1.0-0 libx11-6 libxinerama1 libwebkitgtk-1.0-0 libcanberra0 libjavascriptcoregtk-1.0-0 libpng16-16 \
     libexpat1 \
  && echo "==== Unpacking rainlendar ====" && dpkg --unpack /src/rainlendar2.deb \
  && echo "==== Fixing postinst - Removing sudo calls ====" && sed -i 's/sudo //g' /var/lib/dpkg/info/rainlendar2-pro.postinst \
  && echo "==== Configuring rainlendar ====" && dpkg --configure rainlendar2-pro \
  && echo "==== Cleaning up apt ====" && rm -rf /var/lib/apt/lists/* \
  && echo "==== Cleaning up rainlendar source ====" && rm /src/*.deb

RUN useradd -ms /bin/bash rainlendar

USER rainlendar
ENV HOME /home/rainlendar

CMD rainlendar2
