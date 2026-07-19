# Agent Instructions

These rules apply to every autonomous agent (Copilot coding agent, Copilot CLI, any agentic workflow) working in this repository. There are no exceptions.

## Git Workflow

### Mandatory Branching (No Exceptions)

1. **Start clean.** Before creating a branch: `git checkout main && git pull --ff-only`. If `--ff-only` fails, stop and investigate — never force.
2. **Create a feature branch** from `main`. Never commit or push directly to `main`.
3. **Make changes and commit** on the feature branch.
4. **Push the feature branch** to origin.
5. **Create a pull request** targeting `main`.
6. **Return to `main`:** `git checkout main && git pull --ff-only`.

**Agents MUST NOT:**
- Commit or push directly to `main`
- Use `git push origin main` or any equivalent
- Skip the pull request step
- Push to an existing branch they did not create — always create a **new** branch from `main` for each task

**If an agent finds itself on `main`, it MUST** stop immediately, create a new branch (`git checkout -b feat/<description>` or appropriate prefix), and continue work there.

### Handling Review Feedback

When a reviewer requests changes on an open PR:
1. Check out the existing feature branch: `git checkout <branch-name> && git pull --ff-only`
2. Make the requested changes and commit
3. Push to the same branch (the PR updates automatically)
4. Update the PR description if scope has grown
5. Return to `main`: `git checkout main && git pull --ff-only`

### Branch Naming

| Prefix | When to use |
|--------|-------------|
| `feat/` | New features |
| `fix/` | Bug fixes |
| `docs/` | Documentation changes |

## Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

**Format:**
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`

**Rules:**
- Subject line ≤ 72 characters
- Imperative mood ("add" not "added")
- No period at the end of the subject line
- Separate subject from body with a blank line
- Body explains *what* and *why*, not how

**Every commit MUST include the Co-authored-by trailer:**
```
Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
```

## Pull Requests

- All PRs target `main` and require review before merge.
- Do not hard-wrap PR body text — write each paragraph as a single line and let GitHub soft-wrap it.
- Prefer Unicode arrows (`→`) over ASCII (`->`).

### PR Body in PowerShell

PowerShell mangles backticks, `$`, and `{}` inside double-quoted strings. **Always** write the PR body to a temp file using a single-quoted here-string and pass it via `--body-file`:

```powershell
$prBody = @'
## Summary

Description with `code`, {placeholders}, and $variables rendered correctly.
'@
$prBody | Out-File -FilePath pr-body.tmp -Encoding utf8
gh pr create --title "feat: my change" --body-file pr-body.tmp --base main
Remove-Item pr-body.tmp
```

**Never** use `--body "..."` inline in PowerShell, and never use `@"..."@` (double-quoted here-string) — PowerShell still processes escape sequences inside it.
