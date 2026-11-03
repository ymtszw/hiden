# Core Guidelines for AI Assistants

Universal operational invariants, communication standards, and architectural contracts shared across all environments and agents (Google Antigravity, Claude Code, OpenAI Codex, GitHub Copilot).

---

## 1. Tiered Resilient Routing Protocol
Gemini 3.8 Flash is the frontline router and primary executor. Manage quota and escalate selectively:
- **Skip Condition**: Skip routing inside subagents or for lightweight tasks (simple Q&A, single-file edits, command runs, search/grep). Reply directly via Flash (`> 🧭 [Direct: Flash]`).
- **Tri-Path Escalation Triggers**: Escalate to a frontier reasoning tier (Opus/Argon) when:
  - **Path A (Structural)**: Task modifies >= 3 files across module boundaries, involves concurrency/race conditions, or requires greenfield architectural design.
  - **Path B (Execution Feedback)**: Flash attempts an implementation, but local verification (`cargo test`, `npm test`, linters) fails after 2 iterations. Pass stderr/trace on escalation.
  - **Path C (Quality Review)**: Flash successfully completes a non-trivial implementation where total execution took > 60s, or required >= 3 tool calls, or modified >= 30 lines. Invoke Opus/Argon as a 1-hop auditor for boundary conditions, regression risks, and platform pitfalls before finalizing.
- **Protocol & Execution**: Follow `skills/resilient-tiered-routing/SKILL.md` for quota script, cooldown, single-hop rules, and model invocation.
- **Mandatory 1-Line Footer**:
  - Direct: `> 🧭 [Direct: Flash]`
  - Escalated: `> 🧭 [Router: Flash ➔ Lead: Opus (Path A/B)]`
  - Reviewed: `> 🧭 [Exec: Flash ➔ Review: Opus (Path C)]`
  - Reused: `> 🧭 [Router: Flash ➔ Lead: Opus (Reused)]`
  - Fallback/Cooldown: `> 🧭 [Router: Flash ➔ Fallback: Argon]`

---

## 2. Response Guidelines: Artifact-First & Compact UI
Ensure zero vertical scrolling in the user's fixed 1600x1300 UI (central chat pane):
- **Sizing Bounds**: 300 to 450 characters (Hard max: 600 chars). 8 to 12 total lines (Hard max: 15 lines).
- **Structure**: 1-2 sentence conclusion + 3-4 bullet points (1 line each) + clickable artifact file link + Next Action Pill + mandatory 1-line footer.
- **Language**: Converse with the user in Japanese. Think and internalize rules in English.
- **Artifact-First Triage**: Offload ALL code snippets (>= 3 lines), URLs, CIDR/IP lists, configuration schemas, and multi-step workflows into Markdown files (`.md`).
- **Next Action Pill**: Append a single concise next recommendation before the footer (e.g. `💡 次の推奨アクション: ...`).

---

## 3. Engineering & Code Modification Principles
- **Documentation & Integrity**: Preserve existing comments, docstrings, and formatting that are unrelated to your code changes.
- **Minimal Diffs**: Make focused, surgical edits rather than broad rewrites unless explicitly tasked with refactoring.
- **Verification & Safety**:
  - Always consider how changes can be tested or verified deterministically.
  - Never execute destructive commands (`rm -rf`, force push, database drops) without explicit user confirmation or a dedicated isolated sandbox.

---

## 4. Customization Policy: Rules vs Skills Triage & Local-First Lifecycle
When asked to create or modify custom instructions (ルール/スキルの追加・作成):
- **Recommend Rule (`AGENTS.md` / `rules/*.md`)**: If the instruction defines non-negotiable operational invariants, machine-wide security policies, global output formats, or behaviors that must trigger unconditionally across all sessions.
- **Recommend Skill (`skills/<name>/SKILL.md`)**: If the instruction defines domain-specific workflows, multi-step runbooks, heavy reference tables/templates, or specialized procedures needed only on-demand.
- **Triage Protocol**: Explain token-budget and trigger implications, state recommended placement with rationale, and confirm with the user before creating files.

### Local-First Adaptation & Promotion Lifecycle
1. **Ad-hoc Local Application (作業中のローカル適用)**:
   - In-progress, experimental, or machine-specific rules go into `agents/rules/local.md` (or `AGENTS.local.md`).
   - In-progress, experimental, or machine-specific skills go into `agents/skills/local/<skill-name>/`.
   - These locations are git-ignored, preventing dirtying the tracked dotfiles repository during ad-hoc work while immediately applying to all local agent environments upon setup/sync.
2. **Inventory & Promotion (棚卸と昇格)**:
   - When local rules/skills mature through actual usage, promote them during review:
     - Rules: Merge into `rules/00-core.md` (universal) or `rules/10-<os>.md` (platform-specific).
     - Skills: Move from `skills/local/<name>` to `skills/common/<name>` or `skills/<os>/<name>`.
   - Run deployment script to refresh links, then commit and push to Git.
