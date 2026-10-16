# Contributing

## Workflow

Every task has a GitHub issue, tracked in the **homelab** GitHub Project.

1. Open an issue describing the task and add it to the project.
2. Do the work in commits that reference the issue.
3. The last commit (or the PR) closes it with `Closes #<n>`.

## Commit messages

[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):

```
<type>(<scope>): <description>

[optional body: why, not what]

Refs #<issue>  |  Closes #<issue>
```

- Description in English, imperative, lowercase, no trailing period:
  `feat(immich): add machine learning container`.
- Breaking changes (data migration, manual step on the host, changed port/URL): add `!`
  after the scope and a `BREAKING CHANGE:` footer explaining what to do.

### Types

| Type       | Use for                                                        |
|------------|----------------------------------------------------------------|
| `feat`     | New stack, service or capability                               |
| `fix`      | Fix something broken                                           |
| `refactor` | Restructure without changing behaviour (e.g. secrets to vars)  |
| `perf`     | Resource limits, tuning                                        |
| `chore`    | Maintenance; dependency bumps are `chore(deps)` (Renovate)     |
| `docs`     | README, CLAUDE.md, this file, comments                         |
| `ci`       | GitHub Actions, hooks, Renovate config                         |
| `build`    | Dockerfiles and Komodo builds                                  |
| `revert`   | Revert a previous commit                                       |

### Scopes

- A stack name: `immich`, `ingress`, `monitoring`...
- A server, for changes spanning several of its stacks: `homelab`, `oracle-1`, `oracle-2`
- `komodo` for `komodo/main.toml`
- `repo` for repository-wide changes

### Examples

```
feat(ddns): migrate stack from k3s

Refs #3
```

```
refactor(immich): move database password to a Komodo variable

Closes #7
```

```
fix(ingress)!: serve registry under registry.n1eko.com only

BREAKING CHANGE: docker logins against the old hostname must be redone.
```
