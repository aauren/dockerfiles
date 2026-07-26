#!/bin/sh
#
# Drops privileges to PUID:PGID before handing off to stork-server, so that bind mounted files can
# stay owned by whatever the host already uses rather than forcing everyone onto a baked-in UID.

set -eu

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

# If we were started with docker's --user (or a Kubernetes securityContext) then we are already
# unprivileged and can't drop any further, so get out of the way and trust the caller's choice
if [ "$(id -u)" != "0" ]; then
    exec "$@"
fi

# Note: there is deliberately no chown here. The server keeps all of its state in Postgres and
# writes nothing to disk, so everything you mount in (agent packages, hooks, TLS certs, an env file)
# is read-only to Stork and only has to be readable by PUID. That means we never have to rewrite
# ownership on your bind mounts, which is a rude thing to do to files that live on the host.
exec su-exec "${PUID}:${PGID}" "$@"
