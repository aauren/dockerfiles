FROM alpine:3

# Kept in sync with the pinned stork-server package below by build_container.sh, so the image's
# own metadata (`docker inspect`) reports the same version we tagged it with
LABEL org.opencontainers.image.version="2.5.1"

# ISC publishes Stork to Cloudsmith under any-distro/any-version, which is why this repo URL carries
# no Alpine release in it and we can float the base on alpine:3 without the build ever breaking
ADD --chmod=644 https://dl.cloudsmith.io/public/isc/stork-dev/rsa.BF2C56ECBA97B498.key \
      /etc/apk/keys/stork-dev@isc-BF2C56ECBA97B498.rsa.pub

# Pinned to a specific upstream release so a rebuild never silently drags in a newer stork-server.
# build_container.sh looks up the current stable version and rewrites this line before each build,
# so don't bump it by hand.
# hadolint ignore=DL3018
RUN echo "https://dl.cloudsmith.io/public/isc/stork-dev/alpine/any-version/main" >> /etc/apk/repositories \
      && apk add --no-cache ca-certificates su-exec isc-stork-server=2.5.1.260807142332

# The package's post-install grabs whatever system UID happens to be free, which drifts as Alpine
# adds its own users, so we pin it to 1000 to give bind mounts on the host a stable target to match
RUN deluser stork-server \
      && delgroup stork-server 2>/dev/null || true \
      && addgroup -g 1000 stork-server \
      && adduser -u 1000 -G stork-server -h /var/lib/stork-server -H -D -s /sbin/nologin \
            -g "Stork Server User" stork-server

# Neither directory ships in the package, but the server wants both: hooks for the LDAP hook and
# friends, pkgs for the agent installers it serves out of the web UI. Both are read-only to Stork,
# so they stay root owned and merely need to be world readable
RUN mkdir -p /usr/lib/stork-server/hooks /usr/share/stork/www/assets/pkgs /var/lib/stork-server \
      && chown stork-server:stork-server /var/lib/stork-server

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Used for exposing stork
EXPOSE 8080

# Healthcheck for stork. BusyBox wget has no --delete-after, but --spider is what we wanted anyway
HEALTHCHECK CMD [ "wget", "-q", "--spider", "http://localhost:8080/api/version" ]

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD [ "/usr/bin/stork-server" ]
