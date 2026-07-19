#!/usr/bin/env bash
# Sets up symlinks from this dotfiles repo to the expected locations on the system.
#
# Creates symbolic links so that tools like VS Code / GitHub Copilot
# pick up agents and skills from this version-controlled repo.
#
# Also restores project-level skills managed by the npx skills CLI from
# skills-lock.json (requires Node.js / npx to be available).
#
# Run this script once after cloning the repo on a new machine:
#   bash install.sh

set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -A LINKS=(
    ["$HOME/.copilot/skills"]="$DOTFILES_ROOT/.agents/skills"
    ["$HOME/.copilot/agents"]="$DOTFILES_ROOT/.github/agents"
    ["$HOME/.copilot/instructions"]="$DOTFILES_ROOT/.github/instructions"
)

echo "Creating symlinks..."
for LINK in "${!LINKS[@]}"; do
    TARGET="${LINKS[$LINK]}"
    PARENT="$(dirname "$LINK")"

    if [ -L "$LINK" ]; then
        echo "  Removing existing symlink: $LINK"
        rm "$LINK"
    elif [ -e "$LINK" ]; then
        echo "  WARNING: '$LINK' exists and is not a symlink. Skipping — back it up and remove it manually."
        continue
    fi

    mkdir -p "$PARENT"
    ln -s "$TARGET" "$LINK"
    echo "  Linked: $LINK -> $TARGET"
done


# Restore project-level skills from skills-lock.json
LOCK_FILE="$DOTFILES_ROOT/skills-lock.json"
if [ -f "$LOCK_FILE" ]; then
    if command -v npx &>/dev/null; then
        echo ""
        echo "Restoring project skills from skills-lock.json..."
        (cd "$DOTFILES_ROOT" && npx skills experimental_install --yes)
        echo "  Skills restored."
    else
        echo "  WARNING: npx not found — skipping skill restore. Install Node.js and run 'npx skills experimental_install' manually."
    fi
fi


# Add shell aliases to bash/zsh profile
ALIASES_SCRIPT="$DOTFILES_ROOT/shell/aliases.sh"
if [ -f "$ALIASES_SCRIPT" ]; then
    echo ""
    echo "Configuring shell profile..."
    bash "$ALIASES_SCRIPT"
fi


echo ""
echo "Done. Restart VS Code to pick up changes."
