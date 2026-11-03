# Agent Dotfiles (`agent-dotfiles`)

A unified configuration and skill repository for AI coding agents across multiple machines (macOS, Windows, Linux) and agent runtimes.

Supported Agents:
- **Google Antigravity (AGY)** (`~/.gemini/config/`)
- **Claude Code** (`~/.claude/`)
- **OpenAI Codex** (`~/.codex/`)
- **GitHub Copilot** (`~/.copilot/`)

---

## 1. Directory Structure

```text
agents/
├── rules/                  # Always-on guidelines and operational invariants
│   ├── 00-core.md          # Universal rules (routing, compact UI, integrity, lifecycle)
│   ├── 10-unix.md          # POSIX / macOS / Linux specific conventions
│   ├── 10-windows.md       # Windows / PowerShell specific conventions
│   └── local.md            # (Git-ignored) Machine-local or experimental rules
├── skills/                 # Modular on-demand agent runbooks (SKILL.md)
│   ├── common/             # Cross-platform skills (routing, UI, a11y, docs, etc.)
│   ├── unix/               # Unix / macOS specific skills
│   ├── windows/            # Windows / PowerShell specific skills
│   └── local/              # (Git-ignored) Ad-hoc or machine-local skills
├── setup-unix.sh           # Unix / macOS deployment script
├── setup-windows.ps1       # Windows PowerShell deployment script
└── README.md
```

---

## 2. Deployment

### macOS / Linux / WSL
From the root of `hiden`:
```bash
make agents
```
*(Or directly run `./agents/setup-unix.sh`)*

### Windows (PowerShell)
In a PowerShell terminal:
```powershell
powershell -ExecutionPolicy Bypass -File .\agents\setup-windows.ps1
```
*(Directory junctions are used on Windows so no Administrator elevation is required)*

---

## 3. Local-First Workflow: Ad-hoc Adaptation & Promotion

This repository supports a 2-stage lifecycle: **ad-hoc local adaptation** during daily work, followed by **inventory & promotion** into Git-tracked dotfiles.

### Step 1: Ad-hoc Local Application
When an agent or user crafts a new rule or skill during pair programming:
- **Local Rules**: Add to `agents/rules/local.md` (or `agents/AGENTS.local.md`).
- **Local Skills**: Create a directory under `agents/skills/local/<skill-name>/` with a standard `SKILL.md`.
- **Adopt Existing**: If a skill was created directly inside an agent directory (e.g. `~/.gemini/config/skills/`), run:
  ```powershell
  .\agents\setup-windows.ps1 -Adopt
  ```
  It automatically moves unmanaged folders to `agents/skills/local/` and links them back.

Run `setup-windows.ps1` (or `setup-unix.sh`) to activate. Because skills are deployed as junctions / symlinks, any subsequent edits to files inside the skill are instantly active across all agents without redeploying.

### Step 2: Inventory & Promotion
Periodically review what has accumulated in the local-only areas:

1. **Promote Skills**:
   ```bash
   # Move from local to common (or windows / unix)
   git mv agents/skills/local/<skill-name> agents/skills/common/<skill-name>
   ```
2. **Promote Rules**:
   - Extract validated guidelines from `rules/local.md` and merge them into `rules/00-core.md` (if universal) or `rules/10-windows.md` / `rules/10-unix.md` (if platform-specific).
3. **Deploy & Commit**:
   - Re-run `setup-windows.ps1` or `make agents`.
   - Review git status:
     ```bash
     git status
     git commit -m "feat(agents): promote <skill-name> to common"
     git push
     ```
