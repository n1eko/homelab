#!/bin/sh
# Runs at 01:30 UTC; Kopia snapshots /mnt/backups at 02:30 UTC.
# Dumps are uncompressed on purpose: Kopia compresses and deduplicates them across days.
set -u
status=0
SSH="ssh -i /ssh/id_ed25519 -o UserKnownHostsFile=/ssh/known_hosts -o BatchMode=yes"

# Writes to a temp file first so Kopia never snapshots a half-written dump.
dump() {
  out=$1; shift
  mkdir -p "$(dirname "$out")"
  if "$@" > "$out.tmp"; then
    mv "$out.tmp" "$out"
    echo "$(date -Iseconds) ok   $out ($(du -h "$out" | cut -f1))"
  else
    rm -f "$out.tmp"
    echo "$(date -Iseconds) FAIL $out"
    status=1
  fi
}

dump /backups/homelab/schassis.sql docker exec schassis-db sh -c 'pg_dumpall -U "$POSTGRES_USER"'
# The remote side ignores the command and runs its forced dump script (see remote/).
dump /backups/oracle-1/dumps.tar $SSH ubuntu@100.114.66.100
dump /backups/oracle-2/dumps.tar $SSH ubuntu@100.106.222.107

exit $status
