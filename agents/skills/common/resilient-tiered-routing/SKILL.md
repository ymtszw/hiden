---
name: resilient-tiered-routing
description: >-
  MANDATORY: Execute FIRST for root sessions. Highest priority routing rule.
  Quick-scan via Flash, check quota ONLY when escalating, enforce cooldown tracking on 429/depleted models,
  and route to Opus/Argon using minimalist "Diff-only" or "Full-execution" to maximize AI Pro credits.
---
# Tiered Resilient Routing Protocol (Agy Optimized)

## 0. Self-Suppression Guards (Skip Conditions)
Skip this routing protocol entirely and let the frontline (Flash) execute/reply immediately if:
1. **Subagent Context**: Current execution is inside an `invoke_subagent` session.
2. **Lightweight Task**: Simple Q&A, single-file edits, command runs, grep/search, or casual chat.

## 1. Tri-Path Escalation Triggers (Structural, Feedback & Review)
Escalate to or consult a frontier reasoning tier (Opus/Argon) under these conditions:
* **Path A (Structural Trigger)**: Task inherently involves >= 3 modified files across modules, concurrency/race-condition fixes, or greenfield architectural design.
* **Path B (Execution-Feedback Trigger)**: Flash attempts an implementation, but deterministic verification (compiler errors, `cargo test`, `npm test`, linters) fails after 2 iterations. Attach the exact stderr/trace when escalating.
* **Path C (Quality Review Trigger)**: When Flash successfully finishes a task that took > 60s of total work, or involved >= 3 tool calls / >= 30 lines modified. Pass the git diff to Opus/Argon for a 1-hop audit focusing on edge cases, Windows pitfalls, and regression risk.

## 2. Quota Check, Cooldown & Single-Hop Escalation
When escalated:
1. **Cooldown Tracking**: If a model previously returned a 429 or reported <= 10% in this session, treat as in **Cooldown**; skip to the next tier without running the script.
2. Run quota check:
   - Windows: `powershell -ExecutionPolicy Bypass -File ~\.gemini\config\skills\resilient-tiered-routing\scripts\get-quota.ps1`
   - macOS / Linux: `bash ~/.gemini/config/skills/resilient-tiered-routing/scripts/get-quota.sh`
3. Route order: **Priority 1 (Opus)** if Claude > 10% -> **Priority 2 (Argon)** if Argon > 10% -> **Fallback (Flash Direct)**.
4. **Max 1-Hop Ceiling**: Never cascade sequentially through multiple frontier models. If the chosen leader stalls or fails, fall back to Flash immediately to avoid compounding latency.
5. Reuse existing `conversationId` via `send_message` if active; always pass `Workspace: "inherit"`. Instruct leader for "Direct full-edit or Unified Diff" (Zero Plan-Only).

## 3. Subagent Invocation Guidance
When launching or delegating to the frontier tier:
* **For Path A/B (Lead)**: `invoke_subagent` (TypeName: "self", Role: "Frontier Implementer", Prompt: "Implement/Fix with direct diff/full-edit...").
* **For Path C (Audit)**: `invoke_subagent` (TypeName: "self", Role: "Code Auditor", Prompt: "Review the attached diff against requirements, edge cases, Windows-specific pitfalls, and regressions. Report LGTM or specific risks.").

## 4. Mandatory Footer Guideline
Append exactly one line at the very end of your response using this Japanese format:
- Direct: `> 🧭 [Direct: Flash]`
- Escalated/Reused: `> 🧭 [Router: Flash ➔ Lead: Opus (Path A/B)]`
- Reviewed: `> 🧭 [Exec: Flash ➔ Review: Opus (Path C)]`
- Fallback/Cooldown: `> 🧭 [Router: Flash ➔ Fallback: Argon]`
