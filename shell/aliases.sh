# Shell aliases
# Run this script directly to install it into ~/.bashrc and ~/.zshrc automatically.
# Or source it manually:  source ~/dev/dotfiles/shell/aliases.sh

# ghcp — shorthand for `copilot`
alias ghcp='copilot'

# Auto-install: when executed directly (not sourced), inject the source line
# into ~/.bashrc and ~/.zshrc so the alias is available in every new shell.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    SOURCE_LINE="source \"$SCRIPT_PATH\""

    for RC_FILE in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [ -f "$RC_FILE" ] || [[ "$RC_FILE" == "$HOME/.bashrc" ]]; then
            if ! grep -qF "aliases.sh" "$RC_FILE" 2>/dev/null; then
                echo "" >> "$RC_FILE"
                echo "$SOURCE_LINE" >> "$RC_FILE"
                echo "  Added shell aliases to: $RC_FILE"
            else
                echo "  Shell aliases already present in: $RC_FILE — skipping."
            fi
        fi
    done

    echo "  Run 'source ~/.bashrc' (or open a new terminal) to apply."
fi
