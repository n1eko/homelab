# CLAUDE.md

Homelab infrastructure: Docker Compose stacks across three servers, deployed by Komodo from this
repo (`komodo/main.toml` is the active resource sync).

| Server | Role | Tailscale address |
|--------|------|-------------------|
| homelab | Primary, runs Komodo core | `100.82.54.76` |
| oracle-1 | Oracle Cloud VM, public ingress | `100.114.66.100` (private `10.0.0.16`) |
| oracle-2 | Oracle Cloud VM | `100.106.222.107` |

## This repo is PUBLIC

Every push is published. Never commit a secret value: passwords, tokens, API keys, password
hashes (including `$apr1$`/bcrypt basic-auth), connection strings with credentials, `.env` files.
Personal data (private e-mail addresses) stays out too.

- Compose files reference secrets as `${VAR}`. Configs that can't read env vars use their own
  substitution: Spring `application.yml` placeholders (`${VAR}`), Traefik Go templating
  (`{{ env "VAR" }}`).
- Values are Komodo **secret variables**, created through the Komodo UI/API, never written in
  `main.toml`. The stack maps them in its `environment`, which Komodo writes to `.env`:
  ```toml
  environment = """
  DB_PASSWORD=[[IMMICH_DB_PASSWORD]]
  """
  ```
  Single-quote values containing `$` (e.g. `'[[INGRESS_BASIC_AUTH_USERS]]'`) so compose does not
  interpolate them. Naming: `<STACK>_<NAME>` in upper snake case.
- `.githooks/pre-commit` runs gitleaks plus a local literal denylist
  (`.git/info/secret-denylist`). Requires `git config core.hooksPath .githooks`. Never bypass it
  with `--no-verify`.
- Renovate credentials use `{{ secrets.NAME }}` (configured in the Mend Renovate app).

## Workflow

- Every task has an issue in the **homelab** GitHub Project; commits reference it.
- Commits follow Conventional Commits (`feat(scope): ...`). Types, scopes and examples are in
  `CONTRIBUTING.md`.
- No comments in compose files.
- Changing `main.toml` needs a resource sync in Komodo; changing a compose file needs a redeploy
  of that stack (Renovate bumps are not deployed automatically yet, see #21).

## Structure

- `stacks/<server>/<stack>/` - `compose.yaml` per Komodo stack
- `komodo/main.toml` - servers, stacks, builds, procedures and the resource sync itself
- `builds/` - Dockerfiles for images built by Komodo

### Adding a stack

1. Create `stacks/<server>/<stack>/compose.yaml`.
2. Create any secret variables in Komodo.
3. Add a `[[stack]]` to `komodo/main.toml` with `repo = "n1eko/homelab"`, its `run_directory`
   and `environment`.
4. Push, run the resource sync, deploy the stack.

### Exposing a service publicly

Traefik on oracle-1 (`stacks/oracle-1/ingress`) is the public entry point. Routes live in
`stacks/oracle-1/ingress/dynamic/routes.yml` and are hot-reloaded (the directory is mounted, so
redeploying the stack is enough):

1. Publish the service's port on its host, bound to the Tailscale/private address when possible.
2. Add a router (`entryPoints: [websecure]`, `tls.certResolver: letsencrypt`) and a service
   pointing at the host's address from the table above.
3. Point the DNS record at oracle-1.

Plain HTTP redirects to HTTPS through a catch-all router. Shared middlewares: `basic-auth`, `cors`.
