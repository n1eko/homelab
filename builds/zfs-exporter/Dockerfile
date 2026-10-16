# syntax=docker/dockerfile:1
# zfs_exporter for the homelab monitoring stack, built by Komodo (`zfs-exporter` build in
# komodo/main.toml). Upstream ships no image, so the source is fetched at a pinned tag.

# --- Build stage ---
FROM golang:1.27-bookworm AS build
ARG ZFS_EXPORTER_VERSION=2.4.2
WORKDIR /src
ADD https://github.com/pdf/zfs_exporter.git#v${ZFS_EXPORTER_VERSION} .
RUN go mod download
RUN CGO_ENABLED=0 go build -trimpath -tags netgo \
      -ldflags "-s -w -X github.com/prometheus/common/version.Version=${ZFS_EXPORTER_VERSION}" \
      -o /zfs_exporter .

# --- Runtime stage ---
# Ubuntu 24.04 so zfsutils-linux matches the host's ZFS version (2.2.x).
# The exporter shells out to `zfs` and `zpool`, which talk to the host kernel via /dev/zfs.
FROM ubuntu:24.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends zfsutils-linux \
 && rm -rf /var/lib/apt/lists/*
COPY --from=build /zfs_exporter /usr/local/bin/zfs_exporter
EXPOSE 9134
ENTRYPOINT ["/usr/local/bin/zfs_exporter"]
