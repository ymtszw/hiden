---
name: resilient-tiered-routing
description: >-
  MANDATORY: Execute FIRST for root sessions. Highest priority routing rule.
  Operate frontline via Fast Tier models (Flash), escalate complex tasks directly to Mid Tier (Hydrogen) to preserve weekly quotas,
  and reserve Frontier Tier (Argon/Opus) and Swarms for architecture, audits, and sharded tasks with strict 1-hop ceilings.
---
# Tiered Resilient Routing Protocol

## 0. Three-Tier Architecture & Provider Adapters

Balance responsiveness, cost/quota efficiency, and deep reasoning across platforms while shielding weekly limits:

| Provider / Environment | Fast Tier (Frontline) | Mid Tier (Deep Logic - Standard Quota) | Frontier Tier (Weekly Quota / Audit) | Swarm Coordinator | Quota / Health Check |
|---|---|---|---|---|---|
| **Google / AGY** | Gemini 3.8 Flash | Gemini 4 Hydrogen (Med〜XHigh) | Gemini 4 Argon / Claude Opus | Orchestrator (Argon) | `get-quota.ps1` (Win) / `get-quota.sh` (Unix) |
| **Anthropic / Claude** | Claude Haiku | Claude Sonnet | Claude Opus | Claude Swarm | API rate limits / Claude Code usage |
| **OpenAI / Codex** | GPT-4o mini | o3-mini (high) | o1 / o3 / GPT-4o | Agents SDK | OpenAI organization usage dashboard |
| **GitHub Copilot** | Default / Instant model | Claude 3.5 Sonnet | o1 | Multi-agent Swarm | GitHub Copilot tier limits |

---

## 1. Pre-Execution Gate & Skip Conditions
Before calling file creation or edit tools (`write_file`, `edit_file`) in a root session, run this mechanical check:
- **Mandatory Delegation**: If the prompt explicitly requests parallel development ("並行開発", "並列") or satisfies Path A/S, **never implement directly in the root session**; delegate immediately on Turn 1.
- **Skip Condition (Zero-Hop Direct)**: Skip routing and let Fast Tier execute/reply directly ONLY if:
  1. **Subagent Context**: Current execution is already inside a delegated subagent or worker.
  2. **Strictly Lightweight Task**: Simple Q&A, single-file edits, command runs, grep/search, or casual chat.

---

## 2. Tri-Path Escalation Triggers (Structural, Feedback & Review)
Escalate directly under these conditions without intermediate cascading:
* **Path A (Structural) & Path B (Feedback) ➔ Route to Mid Tier (Hydrogen / Sonnet / o3-mini)**:
  - Task modifies >= 3 files across modules, concurrency fixes, or compiler/test failures after 2 attempts.
  - **Do NOT escalate Path A/B to Frontier models (Argon/Opus/o1)**; Mid Tier models resolve deep logic and errors within standard quotas without touching scarce weekly caps.
* **Path C (Audit & Greenfield) ➔ Route to Frontier Tier (Argon / Opus / o1)**:
  - Greenfield architectural design or final production-level diff audit (edge cases, platform pitfalls, and regressions).
* **Path S (Swarm Parallelism) ➔ Route to Swarm Orchestrator**:
  - Prompt explicitly requests parallel execution or task splits into >= 2 completely independent, non-colliding components/files.
  - **Launch `swarm` on Turn 1**; strictly prohibited to self-implement sequentially in root session. Prohibited only for sequential, tightly coupled edits.

---

## 3. Overhead Minimization, Quota Check & Single-Hop Escalation
When escalated:
1. **Strict Max 1-Hop Ceiling**: Jump directly from Fast Tier to the target tier (Mid or Frontier). Never cascade sequentially (Fast ➔ Mid ➔ Frontier).
2. **Warm Session Reuse**: Reuse existing subagents via `send_message` or in-place model switches (`swarm{action: "model"}`) rather than spawning new processes.
3. **Zero-Payload Referencing**: Always pass inherited workspace and file paths / `.md` artifact references instead of inlining large text blocks into subagent briefs.
4. **Cooldown Tracking**: If a model previously returned a 429 or reported <= 10% remaining in this session, treat as in **Cooldown**; skip to the next tier without running quota checks.
5. **Quota Check** (where supported, e.g. Antigravity local language server):
   - Windows: `powershell -ExecutionPolicy Bypass -File ~\.gemini\config\skills\resilient-tiered-routing\scripts\get-quota.ps1`
   - macOS / Linux: `bash ~/.gemini/config/skills/resilient-tiered-routing/scripts/get-quota.sh`
   - External platforms (Claude/Codex): Check API rate-limit headers or active subscription tier limits.
6. **Route Order**:
   - For Path A/B: Prioritize Mid Tier (Hydrogen / Sonnet / o3-mini) -> Fallback to Fast Tier direct.
   - For Path C: Prioritize Frontier Tier (Opus / Argon / o1) -> Fallback to Mid Tier / Fast Tier direct.

---

## 4. Subagent Invocation Guidance
When delegating via subagent or multi-agent delegation tool:
* **For Path A/B (Mid Implementer)**: Delegate to Mid Tier model (Gemini 4 Hydrogen / Claude Sonnet / o3-mini) with Role: "Mid Implementer", Prompt: "Implement/Fix with direct diff/full-edit...".
* **For Path C (Audit)**: Delegate to Frontier Tier model (Claude Opus / Gemini 4 Argon / o1) with Role: "Code Auditor", Prompt: "Review the attached diff against requirements, edge cases, platform pitfalls, and regressions. Report LGTM or specific risks.".
* **For Path S (Swarm)**: Delegate to platform swarm/orchestrator (Agy: `gemini-pro-orchestrator-g1-pro` + Hydrogen workers; Claude: Claude Swarm; OpenAI: Agents SDK).

---

## 5. Mandatory Footer Guideline
Append exactly one line at the very end of your response using this format:
- Direct: `> 🧭 [Direct: <FastModel>]` (e.g. `> 🧭 [Direct: Flash]`)
- Escalated (Mid): `> 🧭 [Router: <FastModel> ➔ Mid: <MidModel> (Path A/B)]`
- Escalated (Lead): `> 🧭 [Router: <FastModel> ➔ Lead: <FrontierModel> (Path C)]`
- Swarm: `> 🧭 [Swarm: Orchestrator (<n> Workers)]`
- Reviewed: `> 🧭 [Exec: <FastModel> ➔ Review: <FrontierModel> (Path C)]`
- Reused: `> 🧭 [Router: <FastModel> ➔ Mid/Lead: <Model> (Reused)]`
- Fallback/Cooldown: `> 🧭 [Router: <FastModel> ➔ Fallback: <FallbackModel>]`
