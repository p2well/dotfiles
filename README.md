# dotfiles

My dotfiles in order to make me feel at `$home` in no time.

## Structure

```
dotfiles/
├── .agents/
│   └── skills/          # Project skills managed by npx skills CLI
├── copilot/
│   ├── agents/          # Custom GitHub Copilot agents (.agent.md)
│   ├── instructions/    # Coding standards (.instructions.md)
│   └── skills/          # Hand-crafted personal skills (folders with SKILL.md)
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
| `copilot/agents/` | `~/.copilot/agents/` |
| `copilot/instructions/` | `~/.copilot/instructions/` |
| `copilot/skills/` | `~/.copilot/skills/` |
| `skills-lock.json` | restores `.agents/skills/` via `npx skills experimental_install` |

Restart VS Code after running the script.
