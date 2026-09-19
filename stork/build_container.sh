#!/bin/bash
#
# Looks up the latest isc-stork-server version straight from ISC's Cloudsmith repo, pins that
# exact version into the Dockerfile, and tags the image to match. This keeps the published image
# version aligned with upstream stork-server rather than some manually bumped number.
#
# ISC ships Stork on two tracks, the same way they do Kea and BIND: "stork" carries stable, even
# minor releases (2.4.x, 2.2.x, ...) and is what we build by default. "stork-dev" carries odd
# minor development releases (2.5.x, 2.3.x, ...) that get fixes before they're ever backported to
# a stable release, if they get backported at all. Pass "dev" as the first argument to build
# against that track when you need a fix that only landed there.
#
# Usage: ./build_container.sh [stable|dev]

set -euo pipefail

CHANNEL="${1:-stable}"
DOCKERFILE="Dockerfile"

case "${CHANNEL}" in
    stable)
        REPO_NAME="stork"
        KEY_ID="6914F776A579B428"
        ;;
    dev)
        REPO_NAME="stork-dev"
        KEY_ID="BF2C56ECBA97B498"
        ;;
    *)
        echo "Unknown channel '${CHANNEL}', expected 'stable' or 'dev'" >&2
        exit 1
        ;;
esac

REPO_URL="https://dl.cloudsmith.io/public/isc/${REPO_NAME}/alpine/any-version/main"

# Cloudsmith's index only ever carries the packages for its own repo/track, so the highest
# version in it is the newest release on whichever track we asked for
STORK_VERSION=$(curl -sL "${REPO_URL}/x86_64/APKINDEX.tar.gz" \
      | tar -Ozx APKINDEX \
      | awk '/^P:isc-stork-server$/{getline; print substr($0,3)}' \
      | sort -V | tail -n1)

if [ -z "${STORK_VERSION}" ]; then
    echo "Failed to determine latest isc-stork-server version from the ${REPO_NAME} repo" >&2
    exit 1
fi

# apk package versions carry a build timestamp (e.g. 2.4.1.260508132209) that we don't want
# cluttering up the Docker tag, so we tag with just the leading semantic version
IMAGE_VERSION=$(echo "${STORK_VERSION}" | cut -d. -f1-3)

echo "Pinning Dockerfile to ${REPO_NAME}'s isc-stork-server=${STORK_VERSION} (image tag ${IMAGE_VERSION})"

# Rewrite the signing key URL/filename and the apk repository line to point at whichever track
# was requested, regardless of which track the Dockerfile was last pinned to
sed -i -E "s#(https://dl\.cloudsmith\.io/public/isc/)[a-z-]+(/rsa\.)[0-9A-F]+(\.key)#\1${REPO_NAME}\2${KEY_ID}\3#" "${DOCKERFILE}"
sed -i -E "s#(/etc/apk/keys/)[a-z-]+(@isc-)[0-9A-F]+(\.rsa\.pub)#\1${REPO_NAME}\2${KEY_ID}\3#" "${DOCKERFILE}"
sed -i -E "s#(https://dl\.cloudsmith\.io/public/isc/)[a-z-]+(/alpine/any-version/main)#\1${REPO_NAME}\2#" "${DOCKERFILE}"
sed -i -E "/^ +&& apk add/ s/isc-stork-server(=[^ ]+)?/isc-stork-server=${STORK_VERSION}/" "${DOCKERFILE}"
sed -i -E "s/(org\.opencontainers\.image\.version=)\"[^\"]*\"/\1\"${IMAGE_VERSION}\"/" "${DOCKERFILE}"

if [ "${CHANNEL}" = "dev" ]; then
    # Dev-track builds are never what "latest" should mean, so they get a version-pinned tag plus
    # a floating "edge" tag instead, the same convention Alpine itself uses for its own rolling
    # release. "latest" is never touched here
    IMAGE_TAG="${IMAGE_VERSION}-dev"
    docker build --pull --no-cache -t "aauren/stork:${IMAGE_TAG}" -t aauren/stork:edge .
    docker push "aauren/stork:${IMAGE_TAG}"
    docker push aauren/stork:edge
else
    docker build --pull --no-cache -t "aauren/stork:${IMAGE_VERSION}" -t aauren/stork:latest .
    docker push "aauren/stork:${IMAGE_VERSION}"
    docker push aauren/stork:latest
fi
