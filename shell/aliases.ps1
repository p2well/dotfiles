# Shell aliases
# Run this script directly to install it into $PROFILE automatically.
# Or dot-source it manually:  . ~/dev/dotfiles/shell/aliases.ps1

# ghcp — shorthand for `copilot`
function ghcp { copilot @args }

# Auto-install: when executed directly (not dot-sourced), inject the source
# line into $PROFILE so the alias is available in every new shell.
if ($MyInvocation.InvocationName -ne '.') {
    $scriptPath = $MyInvocation.MyCommand.Path
    $sourceLine = ". `"$scriptPath`""

    if (!(Test-Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
        Write-Host "  Created profile: $PROFILE"
    }

    $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    if ($profileContent -notlike "*aliases.ps1*") {
        Add-Content -Path $PROFILE -Value "`n$sourceLine"
        Write-Host "  Added shell aliases to: $PROFILE"
        Write-Host "  Run '. `$PROFILE' or open a new terminal to apply."
    } else {
        Write-Host "  Shell aliases already present in profile — skipping."
    }
}
