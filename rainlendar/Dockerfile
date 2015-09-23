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

ADD http://www.rainlendar.net/download/rainlendar2-pro_2.13.b145-1_amd64.deb /src/rainlendar2.deb

RUN apt-get update \
  && apt-get install -qqy libcurl3 libatk1.0-0 libcairo2 libfontconfig1 libfreetype6 libglib2.0-0 libgtk2.0-0 \
     libpango1.0-0 libx11-6 libxinerama1 libwebkitgtk-1.0-0 libcanberra0 \
  && dpkg -i /src/rainlendar2.deb \
  && rm -rf /var/lib/apt/lists/* \
  && rm /src/*.deb

RUN useradd -ms /bin/bash rainlendar

USER rainlendar
ENV HOME /home/rainlendar

CMD rainlendar2
