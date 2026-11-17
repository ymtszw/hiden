# Core Guidelines for AI Assistants

Universal operational invariants, communication standards, and architectural contracts shared across all environments and agents (Google Antigravity, Claude Code, OpenAI Codex, GitHub Copilot).

---

## 0. Environment & Tool Terminology Mapping
Map differing tool systems and platform terminologies to these abstract actions:

| Abstract Action | Google Antigravity (AGY) | Claude Code | OpenAI Codex / CLI | GitHub Copilot |
|---|---|---|---|---|
| **Command Execution (CLI)** | `run_command` | `Bash` | `execute_command` / bash | Terminal execution |
| **File Read / View** | `read_file` | `View` / `Read` | `read_file` | File access |
| **File Create / Edit** | `write_file` / `edit_file` | `Edit` / `Write` | `apply_patch` / `edit` | File edit |
| **Subagent Delegation** | `invoke_subagent` / `send_message` | Sub-agent / task | Agent delegation | Multi-agent delegation |
| **Process / Task Management** | `manage_task` | background task | process / task | Background process |
| **Artifact Output** | `<conversation>/artifact.md` | Artifact / Markdown | Output file / diff | Output doc / markdown |
| **Fast Tier Model** | Gemini Flash | Claude Haiku | GPT-4o mini, o3-mini | Instant / Default |
| **Mid Reasoning Tier** | Gemini 4 Hydrogen | Claude Sonnet | o3-mini (high) | Claude 3.5 Sonnet |
| **Frontier Tier Model** | Argon / Claude Opus | Claude Opus | o1 / o3 / GPT-4o | o1 |
| **Orchestrator (Swarm)** | Orchestrator (Argon) | Claude Swarm | Operator / Agents | Multi-agent Swarm |

---

## 1. Model Fit & Human-in-the-Loop Advisory (Zero Router Overhead)

Operate under a pragmatic **Human-in-the-Loop Model Fit** principle. Rather than attempting fragile, complex autonomous multi-tier routing in prompts, execute faithfully with the currently active model, and advise the user when a model switch would provide a superior outcome:

### Model Tier Mapping & Context
| Tier | Google / AGY | Claude Code | OpenAI Codex | GitHub Copilot | Best Suited For |
|---|---|---|---|---|---|
| **Fast Tier** | Gemini 3.8 Flash | Claude Haiku | GPT-4o mini, o3-mini | Instant / Default | Routine QA, command runs, code search, single-file edits, git operations |
| **Mid Reasoning Tier** | Gemini 4 Hydrogen | Claude Sonnet | o3-mini (high) | Claude 3.5 Sonnet | Multi-file implementation, bug fixing, test failure recovery |
| **Frontier Tier** | Gemini 4 Argon / Claude Opus | Claude Opus | o1 / o3 / GPT-4o | o1 | Greenfield system architecture, mission-critical security/concurrency audits |
| **Orchestration** | Orchestrator (Argon) | Claude Swarm | Agents SDK | Multi-agent | Independent, non-colliding parallel subtasks |

### Operational Invariants
- **Primary Execution**: By default, execute the task directly with the current model without spinning up subagents or running quota checks.
- **Human-in-the-Loop Advisory Trigger**: When the task clearly mismatches the currently active model, output a concise 1-line advisory before proceeding or asking for confirmation:
  1. **When on Fast Tier (Flash/Haiku)**: If the prompt requests greenfield architectural design, complex concurrency/deadlock audits, or heavy cross-module refactoring ➔ Suggest switching UI model to **Mid Reasoning Tier (Gemini 4 Hydrogen)** or **Frontier Tier (Claude Opus / Argon)**.
  2. **When on Frontier Tier (Argon/Opus)**: If the prompt requests simple file lookups, single commands, or trivial edits ➔ Suggest switching to **Fast Tier (Flash)** to conserve weekly quotas.
  3. **Parallel Subtasks**: When the task naturally splits into >= 2 independent, collision-free subtasks ➔ Suggest running a Swarm (e.g. `/swarm` or Orchestrator).
- **Mandatory 1-Line Footer**:
  - Direct execution: `> 🧭 [Direct: <CurrentModel>]` (e.g. `> 🧭 [Direct: Flash]`)
  - When suggesting switch: `> 🧭 [Direct: <CurrentModel> | Advised: <TargetModel>]`

---

## 2. Response Guidelines: Artifact-First & Compact UI
Ensure zero vertical scrolling in the user's fixed 1600x1300 UI (central chat pane):
- **Sizing Bounds**: 300 to 450 characters (Hard max: 600 chars). 8 to 12 total lines (Hard max: 15 lines).
- **Structure**: 1-2 sentence conclusion + 3-4 bullet points (1 line each) + clickable artifact file link + Next Action Pill + mandatory 1-line footer.
- **Language**: Converse with the user in their preferred language (e.g. Japanese). Internalize rules, think, and code in English.
- **Artifact-First Triage**: Offload ALL code snippets (>= 3 lines), URLs, CIDR/IP lists, configuration schemas, and multi-step workflows into Markdown files (`.md`).
- **Next Action Pill**: Append a single concise next recommendation before the footer (e.g. `💡 Next Action: ...` or localized equivalent) so the user can act immediately:
  - Attach clickable links to any active dev server, deployed environment, or public URL deliverable for instant verification/review.
  - Proactively use available agent action/UI prompts (e.g., interactive choices, slash-command suggestions, UI panel triggers) when they smooth the next step.

---

## 3. Engineering & Code Modification Principles
- **Documentation & Integrity**: Preserve existing comments, docstrings, and formatting that are unrelated to your code changes.
- **Minimal Diffs**: Make focused, surgical edits rather than broad rewrites unless explicitly tasked with refactoring.
- **Verification & Safety**:
  - Always consider how changes can be tested or verified deterministically.
  - Never execute destructive commands (`rm -rf`, force push, database drops) without explicit user confirmation or a dedicated isolated sandbox.

---

## 4. Customization Policy: Rules vs Skills Triage & Local-First Lifecycle
When asked to create or modify custom instructions (rules or skills):
- **Recommend Rule (`AGENTS.md` / `rules/*.md`)**: If the instruction defines non-negotiable operational invariants, machine-wide security policies, global output formats, or behaviors that must trigger unconditionally across all sessions.
- **Recommend Skill (`skills/<name>/SKILL.md`)**: If the instruction defines domain-specific workflows, multi-step runbooks, heavy reference tables/templates, or specialized procedures needed only on-demand.
- **Triage Protocol**: Explain token-budget and trigger implications, state recommended placement with rationale, and confirm with the user before creating files.

### Local-First Adaptation & Promotion Lifecycle
1. **Ad-hoc Local Application**:
   - In-progress, experimental, or machine-specific rules go into `agents/rules/local.md` (or `AGENTS.local.md`).
   - In-progress, experimental, or machine-specific skills go into `agents/skills/local/<skill-name>/`.
   - These locations are git-ignored, preventing dirtying the tracked dotfiles repository during ad-hoc work while immediately applying to all local agent environments upon setup/sync.
2. **Inventory & Promotion**:
   - When local rules/skills mature through actual usage, promote them during review:
     - Rules: Merge into `rules/00-core.md` (universal) or `rules/10-<os>.md` (platform-specific).
     - Skills: Move from `skills/local/<name>` to `skills/common/<name>` or `skills/<os>/<name>`.
   - Run deployment script to refresh links, then commit and push to Git.
