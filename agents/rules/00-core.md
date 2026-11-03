# Core Guidelines for AI Assistants

This file defines global communication preferences and fundamental engineering principles.
It is shared across all environments and agents (Codex, GitHub Copilot, Antigravity, etc.).

## 1. Communication Style
- **Concise & Direct**: Lead with the answer or conclusion. Minimize unsolicited fluffs, preambles, or excessive apologies.
- **Language**: Respond in Japanese unless requested otherwise. Technical terms, commands, and code should remain in standard English.
- **Assumptions vs. Questions**: When requirements have ambiguity:
  - If a standard best practice clearly exists, proceed with reasonable defaults and state the assumption briefly.
  - If it is a critical design choice or irreversible decision, ask concisely before proceeding.

## 2. Engineering & Code Modification Principles
- **Documentation & Integrity**: Preserve existing comments, docstrings, and formatting that are unrelated to your code changes.
- **Minimal Diffs**: Make focused, surgical edits rather than broad rewrites unless explicitly tasked with refactoring.
- **Verification & Safety**:
  - Always consider how changes can be tested or verified.
  - Never execute destructive commands (`rm -rf`, force push, database drops) without explicit confirmation or a dedicated isolated sandbox.
