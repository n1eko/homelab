#!/bin/sh
# Installed on oracle-2 as /usr/local/bin/backup-dump: the forced command for homelab's
# backup SSH key. Streams a tar of consistent dumps to stdout.
set -eu
t=$(mktemp -d)
trap 'rm -rf "$t"' EXIT

sudo docker exec budget-db-1 sh -c 'pg_dumpall -U "$POSTGRES_USER"' > "$t/budget.sql"

tar -C "$t" -cf - .
