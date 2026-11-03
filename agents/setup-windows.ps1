<#
.SYNOPSIS
    Deploy agent-dotfiles to OpenAI Codex, GitHub Copilot, and Google Antigravity on Windows.
.DESCRIPTION
    Builds consolidated rules (00-core + 10-windows + AGENTS.local.md) and deploys skills.
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$BuildDir = Join-Path $ScriptDir "build"
$UserProfile = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)

Write-Host "==> [agents] Setting up agent configurations for Windows..." -ForegroundColor Cyan

# 1. Build consolidated rules
if (-not (Test-Path $BuildDir)) {
    New-Item -ItemType Directory -Path $BuildDir -Force | Out-Null
}

$CoreRule = Join-Path $ScriptDir "rules\00-core.md"
$WinRule = Join-Path $ScriptDir "rules\10-windows.md"
$LocalRule = Join-Path $ScriptDir "AGENTS.local.md"
$DestRuleFile = Join-Path $BuildDir "AGENTS.md"

$RuleContent = @()
if (Test-Path $CoreRule) { $RuleContent += (Get-Content -Raw $CoreRule) }
if (Test-Path $WinRule) { $RuleContent += (Get-Content -Raw $WinRule) }
if (Test-Path $LocalRule) {
    Write-Host "==> [agents] Merging local override: AGENTS.local.md" -ForegroundColor Yellow
    $RuleContent += (Get-Content -Raw $LocalRule)
}

($RuleContent -join "`r`n`r`n") | Set-Content -Path $DestRuleFile -Encoding utf8NoBOM

# Helper for directory link/junction
function Link-ItemSafe {
    param(
        [string]$Target,
        [string]$Link
    )
    if (Test-Path $Link) {
        Remove-Item -Path $Link -Recurse -Force -ErrorAction SilentlyContinue
    }
    try {
        New-Item -ItemType SymbolicLink -Path $Link -Target $Target -ErrorAction Stop | Out-Null
    } catch {
        # Fallback to Directory Junction if symlink privileges are missing
        if (Test-Path $Target -PathType Container) {
            New-Item -ItemType Junction -Path $Link -Target $Target | Out-Null
        } else {
            Copy-Item -Path $Target -Destination $Link -Force
        }
    }
}

# 2. Deploy rules to Codex and Copilot
$CodexDir = Join-Path $UserProfile ".codex"
$CopilotDir = Join-Path $UserProfile ".copilot"
New-Item -ItemType Directory -Path $CodexDir -Force | Out-Null
New-Item -ItemType Directory -Path $CopilotDir -Force | Out-Null

Copy-Item -Path $DestRuleFile -Destination (Join-Path $CodexDir "AGENTS.md") -Force
Copy-Item -Path $DestRuleFile -Destination (Join-Path $CopilotDir "copilot-instructions.md") -Force
Write-Host "  ✓ Deployed rules to ~/.codex/AGENTS.md and ~/.copilot/copilot-instructions.md" -ForegroundColor Green

# 3. Deploy skills (common + windows)
function Deploy-Skills {
    param([string]$DestSkillsDir)
    New-Item -ItemType Directory -Path $DestSkillsDir -Force | Out-Null

    foreach ($cat in @("common", "windows")) {
        $CatDir = Join-Path $ScriptDir "skills\$cat"
        if (Test-Path $CatDir) {
            Get-ChildItem -Directory -Path $CatDir | ForEach-Object {
                $targetSkill = $_.FullName
                $linkSkill = Join-Path $DestSkillsDir $_.Name
                Link-ItemSafe -Target $targetSkill -Link $linkSkill
            }
        }
    }
}

Deploy-Skills -DestSkillsDir (Join-Path $CodexDir "skills")
Deploy-Skills -DestSkillsDir (Join-Path $CopilotDir "skills")
Write-Host "  ✓ Deployed common & windows skills to ~/.codex/skills and ~/.copilot/skills" -ForegroundColor Green

# 4. Configure Antigravity (AGY) if present
$AgyConfigDir = Join-Path $UserProfile ".gemini\config"
if (Test-Path $AgyConfigDir) {
    $CommonSkillsEscaped = (Join-Path $ScriptDir "skills\common").Replace("\", "\\")
    $WinSkillsEscaped = (Join-Path $ScriptDir "skills\windows").Replace("\", "\\")

    $SkillsJsonContent = @"
{
  "entries": [
    {
      "path": "$CommonSkillsEscaped"
    },
    {
      "path": "$WinSkillsEscaped"
    }
  ]
}
"@
    $SkillsJsonPath = Join-Path $AgyConfigDir "skills.json"
    $SkillsJsonContent | Set-Content -Path $SkillsJsonPath -Encoding utf8NoBOM
    Write-Host "  ✓ Registered skills with Antigravity at ~/.gemini/config/skills.json" -ForegroundColor Green
}

Write-Host "==> [agents] Deployment completed successfully!" -ForegroundColor Cyan
