# aauren/stork

The [ISC Stork](https://stork.isc.org) server in a container, built on Alpine and running
unprivileged.

The Stork package comes straight from ISC's own Cloudsmith repo rather than a distro archive, so the
image tracks upstream Stork releases instead of being pinned to whatever version a distro happened to
freeze. Images are `amd64` only for now. See
[aauren/dockerfiles](https://github.com/aauren/dockerfiles/tree/master/stork) for the build config.

## Setting Up PostgreSQL

Stork keeps all of its state in Postgres, so you'll need a database before the server will start:

```sql
CREATE DATABASE stork;
CREATE USER stork WITH PASSWORD '<password>';
GRANT ALL PRIVILEGES ON DATABASE "stork" TO stork;
GRANT ALL ON SCHEMA public TO stork;
CREATE EXTENSION pgcrypto;
```

## Running It

```yaml
---
services:
  stork:
    image: aauren/stork:latest
    container_name: stork
    ports:
      - 8080:8080
    restart: unless-stopped
    environment:
      STORK_DATABASE_HOST: <postgres_host>
      STORK_DATABASE_PORT: 5432
      STORK_DATABASE_NAME: stork
      STORK_DATABASE_USER_NAME: stork
      STORK_DATABASE_PASSWORD: <password>
      # enables Prometheus metrics
      STORK_SERVER_ENABLE_METRICS: true
    #volumes:
    #  - <agent_pkg_cache_path>:/usr/share/stork/www/assets/pkgs
```

Drop that in a directory, run `docker compose up -d`, and log in at `admin`:`admin`. Change that
password as soon as you're in.

Be sure to use `restart: unless-stopped` rather than `on-failure`, because `stork-server` exits with
code 2 on `SIGTERM` even when it shuts down cleanly, and `on-failure` will read a normal `docker
stop` as a crash and restart the container.

## Configuration

Config is all environment variables, passed through to `stork-server` untouched, so the
[Stork ARM](https://stork.readthedocs.io/en/latest/install.html) is the authoritative list. The two
this image adds on top:

- **PUID** - `1000` - UID the server process drops to before starting.
- **PGID** - `1000` - GID the server process drops to before starting.

Setting `--user` (or a Kubernetes `securityContext`) instead works too, in which case `PUID`/`PGID`
are ignored and the container runs as whatever you asked for.

## Volumes

The server writes nothing to disk, so there's no data volume worth keeping - all state is in
Postgres. Both paths below are read-only as far as Stork is concerned, so root owned `644` files work
fine and you never need to `chown` anything to match `PUID`:

- `/usr/share/stork/www/assets/pkgs` - Agent packages to serve from the web UI. Download them from
  the [ISC Cloudsmith repo](https://cloudsmith.io/~isc/repos/stork/packages/) and keep the original
  filenames, which must start with `isc-stork-agent` and end in `.deb`, `.rpm`, or `.apk`.
- `/usr/lib/stork-server/hooks` - Server hooks, such as `isc-stork-server-hook-ldap`.

## Upgrading From 1.x

The 2.0.0 image is a rebuild rather than a version bump, so a few things changed:

- The base moved from Ubuntu to Alpine, and `supervisord` is gone. `stork-server` now runs as PID 1,
  which means it gets `SIGTERM` directly and stops in well under a second instead of waiting out the
  kill timer. The supervisor HTTP interface on `:9001` no longer exists.
- The process runs as UID `1000` instead of root. See `PUID`/`PGID` above if that doesn't suit.
- Drop any `/var/lib/stork` volume from your compose file. That path is the *agent's* data directory
  and never did anything for the server.
- The image is about a third of its former size, 305MB down to 105MB.
