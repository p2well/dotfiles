<#
.SYNOPSIS
    Sets up symlinks from this dotfiles repo to the expected locations on the system.

.DESCRIPTION
    Creates directory junctions so that tools like VS Code / GitHub Copilot
    pick up agents and skills from this version-controlled repo.

    Also restores project-level skills managed by the npx skills CLI from
    skills-lock.json (requires Node.js / npx to be available).

    Run this script once after cloning the repo on a new machine.

.EXAMPLE
    .\install.ps1
#>

$ErrorActionPreference = "Stop"

$dotfilesRoot = $PSScriptRoot

$links = @(
    @{ Target = "$dotfilesRoot\copilot\agents"; Link = "$HOME\.copilot\agents" }
    @{ Target = "$dotfilesRoot\copilot\instructions"; Link = "$HOME\.copilot\instructions" }
    @{ Target = "$dotfilesRoot\copilot\skills"; Link = "$HOME\.copilot\skills" }
)

foreach ($entry in $links) {
    $link   = $entry.Link
    $target = $entry.Target

    if (Test-Path $link) {
        $item = Get-Item $link -Force
        if ($item.LinkType -eq "Junction" -or $item.LinkType -eq "SymbolicLink") {
            Write-Host "  Removing existing link: $link"
            $item.Delete()
        } else {
            Write-Warning "  '$link' exists and is not a symlink. Skipping — back it up and remove it manually."
            continue
        }
    }

    $parentDir = Split-Path $link -Parent
    if (!(Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    New-Item -ItemType Junction -Path $link -Target $target | Out-Null
    Write-Host "  Linked: $link -> $target"
}


# Restore project-level skills from skills-lock.json
$lockFile = Join-Path $dotfilesRoot "skills-lock.json"
if (Test-Path $lockFile) {
    if (Get-Command npx -ErrorAction SilentlyContinue) {
        Write-Host "`nRestoring project skills from skills-lock.json..."
        Push-Location $dotfilesRoot
        try {
            npx skills experimental_install --yes
            Write-Host "  Skills restored."
        } catch {
            Write-Warning "  Failed to restore skills: $_"
            Write-Warning "  Run 'npx skills experimental_install' manually after install."
        } finally {
            Pop-Location
        }
    } else {
        Write-Warning "  npx not found — skipping skill restore. Install Node.js and run 'npx skills experimental_install' manually."
    }
}

Write-Host "`nDone. Restart VS Code to pick up changes."
