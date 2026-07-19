# dotfiles

My dotfiles in order to make me feel at `$home` in no time.

## Structure

```
dotfiles/
├── .agents/
│   └── skills/          # All skills: hand-crafted + npx-managed (skills-lock.json)
├── .github/
│   ├── agents/          # Custom GitHub Copilot agents (.agent.md)
│   └── instructions/    # Coding standards (.instructions.md)
├── shell/
│   ├── aliases.ps1      # PowerShell aliases (dot-source from $PROFILE)
│   └── aliases.sh       # Bash/Zsh aliases (source from ~/.bashrc or ~/.zshrc)
├── install.ps1          # Symlink setup + skill restore script
├── skills-lock.json     # npx skills lockfile (like package-lock.json)
└── README.md
```

## Setup

Clone the repo and run the install script to create symlinks:

```powershell
git clone https://github.com/p2well/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
.\install.ps1
```

This creates the following links and restores project skills:

| Source | Target |
|--------|--------|
| `.agents/skills/` | `~/.copilot/skills/` |
| `.github/agents/` | `~/.copilot/agents/` |
| `.github/instructions/` | `~/.copilot/instructions/` |
| `skills-lock.json` | restores `.agents/skills/` via `npx skills experimental_install` |

Restart VS Code after running the script.

## Shell aliases

The `shell/` directory contains alias definitions for common commands.

| Alias | Expands to |
|-------|-----------|
| `ghcp` | `copilot` |

`install.ps1` automatically adds `shell/aliases.ps1` to your PowerShell `$PROFILE`. For bash/zsh, source `shell/aliases.sh` from your `~/.bashrc` or `~/.zshrc`:

```bash
source ~/dev/dotfiles/shell/aliases.sh
```
