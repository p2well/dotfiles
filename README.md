# dotfiles

My dotfiles in order to make me feel at `$home` in no time.

## Structure

```
dotfiles/
├── copilot/
│   ├── agents/          # Custom GitHub Copilot agents (.agent.md)
│   ├── instructions/    # Coding standards (.instructions.md)
│   └── skills/          # Agent skills (folders with SKILL.md)
├── install.ps1          # Symlink setup script
└── README.md
```

## Setup

Clone the repo and run the install script to create symlinks:

```powershell
git clone https://github.com/p2well/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
.\install.ps1
```

This creates the following links:

| Source | Target |
|--------|--------|
| `copilot/agents/` | `~/.copilot/agents/` |
| `copilot/instructions/` | `~/.copilot/instructions/` |
| `copilot/skills/` | `~/.copilot/skills/` |

Restart VS Code after running the script.
