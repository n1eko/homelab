# CLAUDE.md

Homelab infrastructure: Docker Compose stacks across three servers (**homelab**, **oracle-1**,
**oracle-2**), deployed by Komodo. Successor of the private `n1eko/k3s` repo; stacks are being
migrated here one at a time.

## This repo is PUBLIC

Every push is published. Never commit a secret value: passwords, tokens, API keys, password
hashes (including `$apr1$`/bcrypt basic-auth), connection strings with credentials, `.env` files.

- Compose files reference secrets as `${VAR}`. Configs that can't read env vars (Frigate,
  Spring `application.yml`, Traefik dynamic config) must use their own env substitution.
- Values are Komodo **secret variables**, created in the Komodo UI, never in `main.toml`.
  The stack maps them in `komodo/main.toml`:
  ```toml
  environment = """
  DB_PASSWORD=[[IMMICH_DB_PASSWORD]]
  """
  ```
  Variable naming: `<STACK>_<NAME>` in upper snake case.
- `.githooks/pre-commit` runs gitleaks plus a local literal denylist
  (`.git/info/secret-denylist`). Requires `git config core.hooksPath .githooks`. Never bypass it
  with `--no-verify`.
- Renovate credentials use `{{ secrets.NAME }}` (configured in the Mend Renovate app).

## Workflow

- Every task has an issue in the **homelab** GitHub Project; commits reference it.
- Commits follow Conventional Commits (`feat(scope): ...`). Types, scopes and examples are in
  `CONTRIBUTING.md`.

## Migrating a stack from k3s

1. Copy `stacks/<server>/<stack>/` from `../k3s`, replacing every secret with `${VAR}`.
   Drop comments, especially ones about history (k3s, NodePorts, "moved from"...).
   Reassess whether the stack still makes sense as is (and its related k3s issues).
2. Create the secret variables in Komodo.
3. In `../k3s/komodo/main.toml` (still the active resource sync), point the stack at
   `repo = "n1eko/homelab"` and add its `environment` block.
4. Commit and push here, sync and redeploy in Komodo, verify the service.
5. Remove the stack from `../k3s`.

When every stack is migrated, `komodo/main.toml` and the resource sync move here.

## Structure

- `stacks/<server>/<stack>/` - `compose.yaml` per Komodo stack
- `komodo/main.toml` - Komodo resources (after migration)

Public ingress is Traefik on oracle-1 (`stacks/oracle-1/ingress`), proxying to the other hosts
over Tailscale.
