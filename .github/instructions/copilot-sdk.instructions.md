---
description: 'SDK preference for building with the GitHub Copilot SDK: TypeScript primary, Go and Python secondary'
applyTo: '**/package.json,**/go.mod,**/go.sum,**/pyproject.toml,**/requirements.txt,**/setup.py,**/setup.cfg'
---

# GitHub Copilot SDK Instructions

> **Scope:** These rules apply **only to projects that use the GitHub Copilot SDK as a
> dependency** — either an existing project that already declares it, or a new project
> being set up to use it. If the project does not (and will not) depend on the Copilot
> SDK, ignore this file.
>
> Detect the dependency in the relevant manifest:
> - TypeScript / Node.js: `@github/copilot-sdk` in `package.json`
> - Go: `github.com/github/copilot-sdk/go` in `go.mod`
> - Python: `github-copilot-sdk` in `pyproject.toml` / `requirements.txt`

## Default: TypeScript (primary)

- Use the **TypeScript** GitHub Copilot SDK (`@github/copilot-sdk`) for the majority of use cases.
- Treat TypeScript as the default choice for new work: general agent/app development,
  web and Node.js services, tooling, prototypes, and anything without a strong
  ecosystem-specific reason to choose otherwise.
- When the right SDK is ambiguous, prefer TypeScript — or ask before switching languages.

## Secondary: Go and Python

Reach for a secondary SDK only when the use case is specific to that ecosystem.

### Use the Go SDK (`github.com/github/copilot-sdk/go`) when

- The surrounding project or codebase is already written in Go.
- Building CLIs, systems tooling, daemons, or network services where Go is the natural fit.
- Single-binary distribution, static compilation, or straightforward cross-compilation matters.
- High-concurrency workloads that benefit from goroutines and Go's runtime.
- Integrating with an existing Go toolchain, module, or internal Go library.

### Use the Python SDK (`github-copilot-sdk`) when

- The surrounding project or codebase is already written in Python.
- Data science, machine learning, notebooks, or AI/ML pipeline work.
- Quick scripting, automation, or glue code where Python's ecosystem is fastest.
- Integrating with Python-first libraries or tooling (e.g. pandas, PyTorch, Jupyter).

## Guidance

- Do not mix SDKs within a single component without a clear reason.
- If a secondary SDK is chosen, briefly note why the ecosystem-specific case applies.
- Match the SDK to the existing codebase first; fall back to TypeScript when starting fresh.
