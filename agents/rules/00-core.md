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
| **Frontier Tier Model** | Argon / Claude Opus | Claude Opus / Sonnet | o1 / o3 / GPT-4o | Claude 3.5 Sonnet / o1 |

---

## 1. Tiered Resilient Routing Protocol
Operate under an abstract **Two-Tier Architecture (Fast Tier vs. Frontier Tier)** to balance responsiveness, quota/budget consumption, and reasoning depth:

### Model Tier Mapping
- **Fast Tier (Frontline Router & Primary Executor)**:
  - Lightweight, high-throughput, low-latency model. Runs root sessions and lightweight tasks directly.
  - *Google / AGY*: Gemini Flash (e.g. Gemini 3.8 Flash)
  - *OpenAI / Codex*: Fast/Instant models (e.g. GPT-4o mini, o3-mini) or previous-generation fast tier
  - *Anthropic / Claude*: Claude Haiku
  - *GitHub Copilot*: Default / Instant model
- **Frontier Tier (Deep Reasoning, Architectural Lead & Code Review)**:
  - Heavy reasoning and frontier-grade capability for complex tasks.
  - *Google / AGY*: Argon (or Claude Opus under AI Pro / Ultra subscription)
  - *OpenAI / Codex*: Latest-generation flagship / reasoning models (e.g. o1, GPT-4o)
  - *Anthropic / Claude*: Claude Opus / Sonnet
  - *GitHub Copilot*: Claude 3.5 Sonnet / o1

### Operational Invariants
- **Skip Condition**: Skip routing inside subagents or for lightweight tasks (simple Q&A, single-file edits, command runs, search/grep). Reply directly via Fast Tier (`> 🧭 [Direct: <FastModel>]`).
- **Tri-Path Escalation Triggers**: Escalate to the Frontier Tier when:
  - **Path A (Structural)**: Task modifies >= 3 files across module boundaries, involves concurrency/race conditions, or requires greenfield architectural design.
  - **Path B (Execution Feedback)**: Fast tier attempts an implementation, but local verification (`cargo test`, `npm test`, linters) fails after 2 iterations. Pass stderr/trace on escalation.
  - **Path C (Quality Review)**: Fast tier successfully completes a non-trivial implementation where total execution took > 60s, or required >= 3 tool calls, or modified >= 30 lines. Invoke Frontier Tier as a 1-hop auditor for boundary conditions, regression risks, and platform pitfalls before finalizing.
- **Quota & Cooldown**:
  - If a model hits rate limits (429) or is exhausted (<= 10%), mark in **Cooldown** and failover to the next available tier or back to Fast Tier direct.
  - Follow `skills/resilient-tiered-routing/SKILL.md` for environment-specific quota adapters and single-hop rules.
- **Execution Ceilings**: Max 1-Hop ceiling (no multi-hop cascading). Always pass `Workspace: "inherit"`. Instruct leader for "Direct full-edit or Unified Diff" (Zero Plan-Only).
- **Mandatory 1-Line Footer**:
  - Direct: `> 🧭 [Direct: <FastModel>]` (e.g. `[Direct: Flash]`)
  - Escalated: `> 🧭 [Router: <FastModel> ➔ Lead: <FrontierModel> (Path A/B)]`
  - Reviewed: `> 🧭 [Exec: <FastModel> ➔ Review: <FrontierModel> (Path C)]`
  - Reused: `> 🧭 [Router: <FastModel> ➔ Lead: <FrontierModel> (Reused)]`
  - Fallback/Cooldown: `> 🧭 [Router: <FastModel> ➔ Fallback: <FallbackModel>]`

---

## 2. Response Guidelines: Artifact-First & Compact UI
Ensure zero vertical scrolling in the user's fixed 1600x1300 UI (central chat pane):
- **Sizing Bounds**: 300 to 450 characters (Hard max: 600 chars). 8 to 12 total lines (Hard max: 15 lines).
- **Structure**: 1-2 sentence conclusion + 3-4 bullet points (1 line each) + clickable artifact file link + Next Action Pill + mandatory 1-line footer.
- **Language**: Converse with the user in their preferred language (e.g. Japanese). Internalize rules, think, and code in English.
- **Artifact-First Triage**: Offload ALL code snippets (>= 3 lines), URLs, CIDR/IP lists, configuration schemas, and multi-step workflows into Markdown files (`.md`).
- **Next Action Pill**: Append a single concise next recommendation before the footer (e.g. `💡 Next Action: ...` or localized equivalent).

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
