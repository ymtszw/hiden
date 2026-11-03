---
name: resilient-tiered-routing
description: >-
  MANDATORY: Execute FIRST for root sessions. Highest priority routing rule.
  Operate frontline via Fast Tier models (Flash/Instant/mini), check quota and cooldown when escalating,
  and route to Frontier Tier models (Argon/Opus/o1) using "Diff-only" or "Full-execution" to maximize subscriptions.
---
# Tiered Resilient Routing Protocol

## 0. Two-Tier Architecture & Provider Adapters

Balance responsiveness, cost/quota efficiency, and deep reasoning across different AI subscriptions and platforms:

| Provider / Environment | Fast Tier (Frontline & Direct) | Frontier Tier (Reasoning, Lead & Audit) | Quota / Health Check |
|---|---|---|---|
| **Google / AGY** | Gemini Flash (e.g. 3.8 Flash) | Argon / Claude Opus | `get-quota.ps1` (Win) / `get-quota.sh` (Unix) |
| **Anthropic / Claude** | Claude Haiku | Claude Opus / Sonnet | API rate limits / Claude Code usage |
| **OpenAI / Codex** | GPT-4o mini / o3-mini (low) | o1 / o3 / GPT-4o | OpenAI organization usage dashboard |
| **GitHub Copilot** | Default / Instant model | Claude 3.5 Sonnet / o1 | GitHub Copilot tier limits |

---

## 1. Self-Suppression Guards (Skip Conditions)
Skip this routing protocol entirely and let the frontline (Fast Tier) execute/reply immediately if:
1. **Subagent Context**: Current execution is inside an `invoke_subagent` session.
2. **Lightweight Task**: Simple Q&A, single-file edits, command runs, grep/search, or casual chat.

---

## 2. Tri-Path Escalation Triggers (Structural, Feedback & Review)
Escalate to or consult the Frontier Tier under these conditions:
* **Path A (Structural Trigger)**: Task inherently involves >= 3 modified files across modules, concurrency/race-condition fixes, or greenfield architectural design.
* **Path B (Execution-Feedback Trigger)**: Fast tier attempts an implementation, but deterministic verification (compiler errors, `cargo test`, `npm test`, linters) fails after 2 iterations. Attach the exact stderr/trace when escalating.
* **Path C (Quality Review Trigger)**: When Fast tier successfully finishes a task that took > 60s of total work, or involved >= 3 tool calls / >= 30 lines modified. Pass the git diff to Frontier tier for a 1-hop audit focusing on edge cases, platform pitfalls, and regression risk.

---

## 3. Quota Check, Cooldown & Single-Hop Escalation
When escalated:
1. **Cooldown Tracking**: If a model previously returned a 429 or reported <= 10% remaining in this session, treat as in **Cooldown**; skip to the next tier without running quota checks.
2. **Quota Check** (where supported, e.g. Antigravity local language server):
   - Windows: `powershell -ExecutionPolicy Bypass -File ~\.gemini\config\skills\resilient-tiered-routing\scripts\get-quota.ps1`
   - macOS / Linux: `bash ~/.gemini/config/skills/resilient-tiered-routing/scripts/get-quota.sh`
3. **Route Order**: Prioritize highest capability available (e.g. Opus/o1 -> Argon/Sonnet) -> Fallback to Fast Tier direct.
4. **Max 1-Hop Ceiling**: Never cascade sequentially through multiple frontier models. If the chosen leader stalls or fails, fall back to Fast Tier immediately to avoid compounding latency.
5. **Session Reuse**: Reuse existing `conversationId` via `send_message` if active; always pass `Workspace: "inherit"`. Instruct leader for "Direct full-edit or Unified Diff" (Zero Plan-Only).

---

## 4. Subagent Invocation Guidance
When launching or delegating to the frontier tier:
* **For Path A/B (Lead)**: `invoke_subagent` (TypeName: "self", Role: "Frontier Implementer", Prompt: "Implement/Fix with direct diff/full-edit...").
* **For Path C (Audit)**: `invoke_subagent` (TypeName: "self", Role: "Code Auditor", Prompt: "Review the attached diff against requirements, edge cases, platform pitfalls, and regressions. Report LGTM or specific risks.").

---

## 5. Mandatory Footer Guideline
Append exactly one line at the very end of your response using this format:
- Direct: `> 🧭 [Direct: <FastModel>]` (e.g. `> 🧭 [Direct: Flash]`)
- Escalated/Reused: `> 🧭 [Router: <FastModel> ➔ Lead: <FrontierModel> (Path A/B)]`
- Reviewed: `> 🧭 [Exec: <FastModel> ➔ Review: <FrontierModel> (Path C)]`
- Fallback/Cooldown: `> 🧭 [Router: <FastModel> ➔ Fallback: <FallbackModel>]`
