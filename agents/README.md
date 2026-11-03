# Agent Dotfiles (agent-dotfiles)

A unified configuration and skill repository for AI coding agents across machines and environments.

Supported Agents:
- **OpenAI Codex** (`~/.codex/`)
- **GitHub Copilot** (`~/.copilot/`)
- **Claude Code** (`~/.claude/`)
- **Google Antigravity (AGY)** (`~/.gemini/config/`)

---

## 1. Directory Structure

```text
agents/
├── rules/                  # Always-on guidelines and personality rules
│   ├── 00-core.md          # Universal communication style & core principles
│   ├── 10-unix.md          # POSIX / macOS / Linux specifics
│   └── 10-windows.md       # Windows / PowerShell specifics
├── skills/                 # On-demand runbooks (SKILL.md format)
│   ├── common/             # Cross-platform / general skills
│   ├── unix/               # Unix-only skills
│   └── windows/            # Windows-only skills
├── setup-unix.sh           # Unix / macOS deployment script
├── setup-windows.ps1       # Windows PowerShell deployment script
└── AGENTS.local.md         # (Git-ignored) Machine or secret local rules
```

---

## 2. Setup / Deployment

### macOS / Linux / WSL
From the root of `hiden`:
```bash
make agents
```
*(Or directly run `./agents/setup-unix.sh`)*

### Windows (PowerShell)
In a PowerShell window:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\agents\setup-windows.ps1
```

---

## 3. Local & Work Overrides (`AGENTS.local.md`)
To add company-specific or machine-local instructions without committing them to the Git repository:
1. Create `agents/AGENTS.local.md`.
2. Add your local rules.
3. Re-run `make agents` (or `.\agents\setup-windows.ps1`).

The setup script automatically appends `AGENTS.local.md` to the generated `AGENTS.md` during deployment.
