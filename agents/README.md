# Agent Dotfiles (`agent-dotfiles`)

A unified configuration and skill repository for AI coding agents across multiple machines (macOS, Windows, Linux) and agent runtimes.

Supported Agents:
- **Google Antigravity (AGY)** (`~/.gemini/config/`)
- **Claude Code** (`~/.claude/`)
- **OpenAI Codex** (`~/.codex/`)
- **GitHub Copilot** (`~/.copilot/`)

For web-based AI apps (such as `chatgpt.com` and `gemini.google.com`), use the manually installed [web custom instructions](web/custom-instructions.md).

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
├── web/
│   └── custom-instructions.md # Copyable response preferences for web apps
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

### Web-based AI apps

Copy the entire contents of [web/custom-instructions.md](web/custom-instructions.md) into the web app's custom instruction field:

- **ChatGPT**: Settings > Personalization > Custom instructions > **ChatGPT**. The separate **Codex** entry is for Codex instructions.
- **Gemini**: Settings > Personal context (or Personal Intelligence) > Your instructions for Gemini. Availability and labels depend on the account and rollout; work or school accounts may not offer this setting.

Save the instructions, then try a new chat. These are response preferences, so exact character counts, line counts, and rendering are not guaranteed. Neither `make agents` nor the platform setup scripts update web settings.

#### Keeping the Web Prompt in Sync

The web prompt is a manually maintained adaptation of the response guidelines in [rules/00-core.md](rules/00-core.md) and [chat-response-guidelines/SKILL.md](skills/common/chat-response-guidelines/SKILL.md). When changing those guidelines, review and update the web prompt in the same PR. Keep this file as the shared copyable text for both web apps.

The web adaptation deliberately uses flexible size targets and an inline fallback when document creation is unavailable. It keeps necessary details and citations in the response. It omits local filesystem conventions, model routing, delegation requirements, and routing footers because custom instructions alone do not provide those capabilities.

After merging a web prompt change, manually replace the saved text in each web app. For an optional scheduled check, monitor `agents/web/custom-instructions.md` on the default branch of the public `ymtszw/hiden` repository, record the last successfully checked commit, and report relevant changes with the complete replacement text. Report retrieval failures without treating them as unchanged content. A scheduled check should not claim that it updated account settings; replacing the saved instructions remains a manual step. No scheduled task is installed by this repository.

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
