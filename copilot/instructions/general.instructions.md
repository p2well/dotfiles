---
description: 'Personal, always-on Git and workflow rules that apply across every repository'
applyTo: '**'
---

# General Instructions

## Git and Workflow Rules

### ⛔ Mandatory Branching Workflow (No Exceptions)

**Every change — regardless of actor, agent mode, or admin privilege — MUST follow this workflow:**

0. **Start clean:** Before branching, make sure you're on an up-to-date `main` with a clean working tree: `git checkout main && git pull --ff-only`. If `--ff-only` fails, stop and investigate — never force. This guarantees every branch starts from fresh `main`.
1. **Create a feature branch** from `main` (never commit directly to `main`).
2. **Make changes and commit** on the feature branch.
3. **Push the feature branch** to origin.
4. **Create a pull request** targeting `main`.
5. **Switch back to `main`:** Run `git checkout main && git pull --ff-only` so the working tree is clean and ready for the next task.
6. **Get review approval** and merge via the PR.

**Handling review feedback on an open PR:**
If a reviewer requests changes on a PR the agent created, the agent MUST:
1. Check out the existing feature branch: `git checkout <branch-name> && git pull --ff-only`.
2. Make the requested changes and commit.
3. Push to the same branch (the PR updates automatically).
4. Update the PR description if the scope of changes has grown (use `gh pr edit <number> --body-file <tempfile>`; see the PR body formatting rules below).
5. Switch back to `main`: `git checkout main && git pull --ff-only`.

**This rule is absolute and applies to:**
- All AI agents (Copilot coding agent, Copilot CLI, any agentic workflow, any mode)
- All human contributors including repository admins
- All automated processes and bots
- Emergency hotfixes (create a short-lived branch, still use a PR)

**Agents MUST NOT:**
- Commit directly to `main`
- Push directly to `main`
- Use `git push origin main` or any equivalent
- Skip the pull request step for any reason
- Push to an existing branch they did not create — always create a **new** branch from `main` for each task, even when fixing a bug discovered on another branch

**If an agent finds itself on `main`, it MUST:**
1. Stop immediately
2. Create a new branch: `git checkout -b feat/<description>` or appropriate prefix
3. Continue work on the new branch
4. Push the branch and create a PR

### Branching Conventions

- Default branch: `main`.
- Feature branches: `feat/<description>`.
- Documentation branches: `docs/<description>`.
- Fix branches: `fix/<description>`.
- PRs target `main` unless explicitly specified otherwise.

### Pull Requests

- PRs must be reviewed before merge.

#### PR body formatting (PowerShell)

PowerShell treats backticks (`` ` ``), dollar signs (`$`), and curly braces in double-quoted strings as special characters. This causes garbled PR descriptions when using inline `--body` arguments with `gh pr create` or `gh pr edit`.

> **Note:** This is a PowerShell-specific quoting issue. On other shells (e.g. bash/zsh with here-docs or single quotes) inline `--body` may be fine — apply this rule when working in PowerShell.

**Always use `--body-file` instead of `--body`:**

```powershell
# Write the PR body to a temporary file first
$prBody = @"
## Summary

Description with `code`, {placeholders}, and $variables rendered correctly.
"@
$prBody | Out-File -FilePath pr-body.tmp -Encoding utf8
gh pr create --title "docs: my change" --body-file pr-body.tmp --base main
Remove-Item pr-body.tmp
```

**Agents MUST NOT** pass PR descriptions inline via `--body "..."` in PowerShell — always write to a temp file and use `--body-file`.
