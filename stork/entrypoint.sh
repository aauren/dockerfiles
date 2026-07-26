#!/bin/sh
#
# Drops privileges to PUID:PGID before handing off to stork-server, so that bind mounted files can
# be owned by whatever the host happens to use rather than forcing everyone onto a baked-in UID.

set -eu

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

# If we were started with docker's --user (or a Kubernetes securityContext) then we can't chown or
# drop privileges anyway, so we get out of the way and trust the caller picked IDs that work
if [ "$(id -u)" != "0" ]; then
    exec "$@"
fi

# su-exec takes numeric IDs directly, which is why we never bother remapping the packaged
# stork-server account, we only fix up the two paths Stork actually writes to. Note that everything
# else you mount in (hooks, TLS certs, an env file) is read-only to Stork and is deliberately left
# alone, so those only need to be readable by PUID, not owned by it.
chown -R "${PUID}:${PGID}" /var/lib/stork-server /usr/share/stork/www/assets/pkgs

exec su-exec "${PUID}:${PGID}" "$@"
