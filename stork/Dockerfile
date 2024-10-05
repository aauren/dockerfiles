FROM ubuntu:24.04

# Install curl first
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl

# Install Stork apt repos
COPY bash.deb.sh /bash.deb.sh
RUN /bash.deb.sh

# Install Stork
# hadolint ignore=DL3008
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      isc-stork-server wget supervisor procps ca-certificates \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

# Setup directories
RUN mkdir -p /var/log/supervisor \
      && mkdir -p /etc/supervisor/conf.d/ \
      && mkdir -p /usr/lib/stork-server/hooks

# COPY config files
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY stork-server.conf /etc/supervisor/conf.d/stork-server.conf

ENTRYPOINT [ "/bin/bash", "-c", "supervisord -c /etc/supervisor/supervisord.conf"]

# Used for exposing stork
EXPOSE 8080

# Used for exposing the supervisord HTTP server if desired, see:
# http://supervisord.org/configuration.html#inet-http-server-section-settings
#EXPOSE 9091

# Healthcheck for stork
HEALTHCHECK CMD [ "wget", "--delete-after", "-q", "http://localhost:8080/api/version" ]
