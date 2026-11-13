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

## 1. Tiered Resilient Routing Protocol
Operate under an abstract **Three-Tier Architecture (Fast Tier ➔ Mid Reasoning Tier ➔ Frontier Tier / Swarm)** to balance responsiveness, quota/budget consumption, and reasoning depth while shielding scarce weekly limits:

### Model Tier Mapping & UI Selection Guidelines
- **Fast Tier (Frontline Router & Primary Executor)**:
  - Lightweight, high-throughput, low-latency model. Runs root sessions and lightweight tasks directly.
  - *Google / AGY*: Gemini Flash (e.g. Gemini 3.8 Flash)
  - *OpenAI / Codex*: Fast/Instant models (e.g. GPT-4o mini, o3-mini) or previous-generation fast tier
  - *Anthropic / Claude*: Claude Haiku
  - *GitHub Copilot*: Default / Instant model
  - *UI Default Selection*: **Primary Default**. Use for routine QA, command runs, code search, and single-file edits to avoid burning thinking tokens.
- **Mid Reasoning Tier (Standard Quota / Deep Logic & Debugging)**:
  - Deep-reasoning model consuming standard/burst quota (NOT weekly quotas). Handles multi-file refactoring and bug fixing.
  - *Google / AGY*: Gemini 4 Hydrogen (Medium/High/XHigh)
  - *OpenAI / Codex*: o3-mini (high)
  - *Anthropic / Claude*: Claude Sonnet
  - *GitHub Copilot*: Claude 3.5 Sonnet
  - *UI Default Selection*: **Coding-Heavy Default**. Select when dedicating a session to heavy implementation to eliminate routing overhead completely.
- **Frontier Tier (Deep Reasoning, Architectural Lead & Code Review)**:
  - Heavy reasoning and frontier-grade capability for greenfield architecture and final quality audits (consumes scarce weekly quota).
  - *Google / AGY*: Argon (or Claude Opus under AI Pro / Ultra subscription)
  - *OpenAI / Codex*: Latest-generation flagship / reasoning models (e.g. o1, GPT-4o)
  - *Anthropic / Claude*: Claude Opus
  - *GitHub Copilot*: o1
- **Orchestration Tier (Swarm Coordinator)**:
  - Multi-agent swarm coordinator for sharded, independent subtasks.
  - *Google / AGY*: Orchestrator (Argon) (`gemini-pro-orchestrator-g1-pro`) with Hydrogen workers.
  - *Anthropic / Claude*: Claude Swarm (Opus/Sonnet coordinator with Sonnet workers).
  - *OpenAI / Codex*: OpenAI Agents SDK / Operator coordinator with o3-mini/4o workers.
  - *GitHub Copilot*: Workspace multi-agent orchestration.

### Operational Invariants & Overhead Minimization
- **Skip Condition (Zero-Hop Execution)**: Skip routing inside subagents or for lightweight tasks (simple Q&A, single-file edits, command runs, search/grep). Reply directly via Fast Tier (`> 🧭 [Direct: <FastModel>]`).
- **Tri-Path Escalation Triggers**:
  - **Path A (Structural) & Path B (Execution Feedback)**: Escalate directly to **Mid Reasoning Tier (Gemini 4 Hydrogen / Claude Sonnet / o3-mini)** to resolve complex logic and compiler errors WITHOUT burning scarce weekly Frontier quotas.
  - **Path C (Quality Review & Greenfield)**: Escalate to **Frontier Tier (Argon / Opus / o1)** ONLY for greenfield architectural design or final production-level audit on diffs.
  - **Swarm Trigger**: Strictly prohibited for sequential or tightly coupled changes. Trigger `swarm` ONLY when a task splits into >= 2 completely independent, non-colliding components/files requiring parallel workers.
- **Overhead Minimization Rules**:
  - **Strict Max 1-Hop Ceiling**: Never cascade sequentially (e.g. Flash ➔ Hydrogen ➔ Argon). Jump directly from Fast Tier to the target tier in a single hop.
  - **Warm Session Reuse**: Reuse existing subagents via `send_message` or in-place model switches (`swarm{action: "model"}`) rather than spawning new processes.
  - **Zero-Payload Referencing**: Always pass `Workspace: "inherit"` and reference file paths / `.md` artifacts instead of inlining large text blocks into subagent briefs. Instruct leaders for "Direct full-edit or Unified Diff" (Zero Plan-Only).
- **Quota & Cooldown**:
  - If a model hits rate limits (429) or is exhausted (<= 10%), mark in **Cooldown** and failover to the next available tier or back to Fast Tier direct.
  - Follow `skills/resilient-tiered-routing/SKILL.md` for environment-specific quota adapters and single-hop rules.
- **Mandatory 1-Line Footer**:
  - Direct: `> 🧭 [Direct: <FastModel>]` (e.g. `[Direct: Flash]`)
  - Escalated (Mid): `> 🧭 [Router: <FastModel> ➔ Mid: <MidModel> (Path A/B)]`
  - Escalated (Lead): `> 🧭 [Router: <FastModel> ➔ Lead: <FrontierModel> (Path C)]`
  - Swarm: `> 🧭 [Swarm: Orchestrator (<n> Workers)]`
  - Reviewed: `> 🧭 [Exec: <FastModel> ➔ Review: <FrontierModel> (Path C)]`
  - Reused: `> 🧭 [Router: <FastModel> ➔ Lead/Mid: <Model> (Reused)]`
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
