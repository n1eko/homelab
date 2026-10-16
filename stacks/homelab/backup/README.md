# backup

`dump.sh` runs nightly at 01:30 UTC and writes consistent database dumps to `/mnt/backups`,
which Kopia snapshots at 02:30 UTC (see `../kopia`).

| Dump | Source |
|------|--------|
| `homelab/schassis.sql` | schassis Postgres (`pg_dumpall`) |
| `homelab/komodo-mongo.archive` | Komodo's MongoDB: resources, users and every secret variable |
| `oracle-1/dumps.tar` | Vaultwarden (SQLite + files) and schassis MongoDB, via `remote/oracle-1-dump.sh` |
| `oracle-2/dumps.tar` | Budget Tracker Postgres, via `remote/oracle-2-dump.sh` |

The remote scripts are installed on each Oracle host as `/usr/local/bin/backup-dump`, the forced
command of the backup SSH key (`/mnt/docker/backup/ssh` on homelab).

## Restoring Komodo

The Kopia repository is encrypted with `KOPIA_REPOSITORY_PASSWORD`, which is itself a Komodo
variable. Keep a copy of it in a password manager: without it, the dump below can't be read.

1. Restore `homelab/komodo-mongo.archive` from Kopia to the homelab host.
2. Start Komodo's MongoDB (with its original root credentials) and stop Komodo core.
3. Load the archive, replacing what is there:
   ```sh
   docker exec -i komodo-mongo-1 sh -c 'mongorestore --archive --drop -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin' < komodo-mongo.archive
   ```
4. Start Komodo core and check that stacks and variables are back.
