# gql-local-router

Local development orchestration for the personal-enterprise GraphQL layer. Starts all NestJS subgraphs, composes the federated supergraph schema, and runs Apollo Router — all with a single command.

This repo is not deployed. The production equivalent is [`gql-router`](https://github.com/Strangebrewer/gql-router), which runs Apollo Router on Cloud Run against the production subgraphs.

---

## How It Works

Apollo Federation 2 requires a composed supergraph schema — a single document that merges each subgraph's SDL and encodes the routing rules for cross-subgraph field resolution. In production, this composition happens as part of the deployment pipeline. Locally, it's handled by `rover supergraph compose`, which introspects each running subgraph and produces the schema that Apollo Router needs to start.

`pnpm run dev` handles the full sequence automatically:

1. All three subgraphs start in parallel
2. Once their ports are open, `rover` composes the supergraph schema
3. Apollo Router starts on port 4000 against the composed schema

---

## Prerequisites

Run once after cloning:
```bash
pnpm run setup
```

This installs two tools:

- **rover CLI** — Apollo's schema management and composition tool, installed globally on your machine
- **Apollo Router binary** — downloaded into this repo directory, gitignored, needs to be re-downloaded after a fresh clone

Both are platform-aware — `setup.sh` detects your OS and installs the correct version for Linux/Mac or Windows (Git Bash). The router start script does the same check at runtime.

---

## Setup

Each subgraph needs its own `.env.local` before this will work. See each subgraph's `.env.example` for required variables.

Copy `.env.example` to `.env.local` in this repo and add your RSA private key — this is used only for generating test tokens locally.

```bash
pnpm install
pnpm run setup
pnpm run dev
```

Apollo Router will be available at `http://localhost:4000/graphql`. The Apollo Sandbox explorer is enabled at the same URL.

---

## Generating a Test JWT

All resolvers require authentication. To generate a Bearer token for use in the Sandbox:

```bash
pnpm run token
```

Paste the output into the Sandbox Authorization header as `Bearer <token>`. Tokens are valid for 24 hours.

---

## Ports

| Service | Port |
|---|---|
| Apollo Router | 4000 |
| gql-home-maintenance | 4001 |
| gql-recipes | 4002 |
| gql-project-mgr | 4003 |

---

## Adding a Subgraph

When a new subgraph is added to the project:

1. Add an entry to `supergraph.yaml`
2. Add the port to `router.yaml` CORS origins if frontend services need access
3. Add the subgraph to the `start:subgraphs` and `dev` scripts in `package.json`

---

## Directory Layout

This repo expects sibling directories within the same parent:

```
graphql/
  gql-local-router/
  gql-home-maintenance/
  gql-recipes/
  gql-project-mgr/
```
