#!/bin/sh
# Installed on oracle-1 as /usr/local/bin/backup-dump: the forced command for homelab's
# backup SSH key. Streams a tar of consistent dumps to stdout.
set -eu
t=$(mktemp -d)
trap 'sudo rm -rf "$t"' EXIT

# Vaultwarden: an online SQLite backup (safe while the server is running) plus the
# attachments, sends, keys and config next to it.
sudo docker run --rm -v /mnt/docker/vaultwarden/vw-data:/data -v "$t":/out alpine:3.20 sh -c '
  apk add --no-cache sqlite >/dev/null &&
  sqlite3 /data/db.sqlite3 ".backup /out/vaultwarden.sqlite3" &&
  tar -C /data --exclude="./db*.sqlite3*" --exclude=./icon_cache --exclude=./tmp -cf /out/vaultwarden-files.tar .' >&2

sudo docker exec schassis-mongodb sh -c 'mongodump --archive --quiet -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin' > "$t/schassis-mongo.archive"

sudo tar -C "$t" -cf - .
