# gql-local-router — Claude Context

## What This Is

Local development orchestration for the personal-enterprise GraphQL layer. Starts all NestJS subgraphs, composes the supergraph schema via `rover`, and runs Apollo Router locally. Not deployed anywhere — the production equivalent is `gql-router`.

---

## How It Works

1. `pnpm run dev` starts all four subgraphs in parallel via `concurrently`
2. `wait-on` polls until all subgraph ports are open (4001–4004)
3. `rover supergraph compose` introspects each subgraph and generates `supergraph-schema.graphql`
4. Apollo Router starts against the composed schema on port 4000

`supergraph-schema.graphql` is generated at runtime and gitignored — never commit it.

---

## Prerequisites

Run once after cloning:
```bash
pnpm run setup
```

`scripts/setup.sh` installs both required tools:
- **rover CLI** — installed globally on the machine
- **Apollo Router binary** — downloaded into this directory, gitignored

### Platform-Aware Scripts

Apollo Router and rover distribute separate binaries for Linux/Mac and Windows. `scripts/setup.sh` detects the OS via `$OSTYPE` and installs the correct versions — using the `nix` URLs on Linux/Mac and the Windows URLs on Git Bash (`msys`/`cygwin`). `scripts/start-router.sh` applies the same check to run either `./router` or `./router.exe`. Both binaries are gitignored.

---

## Ports

| Service | Port |
|---|---|
| Apollo Router | 4000 |
| gql-vehicles | 4001 |
| gql-home | 4002 |
| gql-recipes | 4003 |
| gql-projects | 4004 |

These are hardcoded in `supergraph.yaml`, `router.yaml`, and the `start:subgraphs` script. If a port needs to change, update all three.

---

## Directory Layout Assumption

This repo assumes sibling directories in the same parent folder:

```
graphql/
  gql-local-router/   ← this repo
  gql-vehicles/
  gql-home/
  gql-recipes/
  gql-projects/
```

The `start:subgraphs` script uses `pnpm -C ../gql-*` to start each subgraph. Each subgraph must have its own `.env.local` configured before running.

---

## Adding a New Subgraph

1. Add an entry to `supergraph.yaml` with the new subgraph's name and port
2. Add the new port to the CORS `origins` list in `router.yaml` if needed
3. Add `"pnpm -C ../gql-<name> run start:dev"` to the `start:subgraphs` script in `package.json`
4. Add `tcp:<port>` to the `wait-on` list in the `dev` script in `package.json`

---

## Scripts

| Script | Description |
|---|---|
| `pnpm run setup` | Installs rover CLI globally and downloads the Apollo Router binary into this directory |
| `pnpm run compose` | Composes the supergraph schema from running subgraphs |
| `pnpm run start:subgraphs` | Starts all subgraphs in parallel |
| `pnpm run start:router` | Starts Apollo Router (requires composed schema) |
| `pnpm run dev` | Full local stack: subgraphs + compose + router |
