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
│   ├── aliases.ps1      # PowerShell aliases (self-installing)
│   └── aliases.sh       # Bash/Zsh aliases (self-installing)
├── install.ps1          # Windows setup: symlinks + skills + shell aliases
├── install.sh           # Linux/macOS setup: symlinks + skills + shell aliases
├── skills-lock.json     # npx skills lockfile (like package-lock.json)
└── README.md
```

## Setup

Clone the repo and run the install script for your platform:

**Windows (PowerShell)**
```powershell
git clone https://github.com/p2well/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
.\install.ps1
```

**Linux / macOS (bash)**
```bash
git clone https://github.com/p2well/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
bash install.sh
```

Both scripts create the following links, restore project skills, and install shell aliases:

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

The install scripts handle this automatically. To install aliases standalone, run the script for your shell directly — it is idempotent:

**PowerShell:** `.\shell\aliases.ps1`

**Bash / Zsh:** `bash ~/dev/dotfiles/shell/aliases.sh`
