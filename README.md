# homelab

Docker Compose stacks for my homelab and two Oracle Cloud servers, deployed by
[Komodo](https://komo.do) from this repo.

- `stacks/<server>/<stack>/` - one Komodo stack per directory
- `komodo/main.toml` - servers, stacks, builds and procedures (Komodo resource sync)
- `builds/` - images built by Komodo
- `stacks/oracle-1/ingress/` - Traefik, the public entry point for every `*.n1eko.com` service

## Secrets

No secret lives in this repo. Compose files reference them as `${VAR}`; the value is a
secret variable in Komodo, injected through the stack's `environment` in `komodo/main.toml`:

```toml
environment = """
DB_PASSWORD=[[IMMICH_DB_PASSWORD]]
"""
```

Commits are scanned by [gitleaks](https://github.com/gitleaks/gitleaks) locally
(`.githooks/pre-commit`) and in CI.

## Setup

```sh
git config core.hooksPath .githooks
```

See `CONTRIBUTING.md` for the workflow and commit conventions.
