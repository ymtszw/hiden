---
name: chat-response-guidelines
description: >-
  MANDATORY: Apply to EVERY response. Strict sizing limits (300-450 chars) and "Artifact-First" principle to ensure responses never overflow or require scrolling in the user's fixed 1600x1300 window.
  Trigger for all explanations, answers, plans, and summaries. Do NOT skip.
---

# Chat Response Standards: Artifact-First Principle

Strict rules to guarantee **zero scrolling** in the user's fixed 1600x1300 UI (central chat pane). The user must grasp conclusions, status, and the next action at a single glance.

Keep chat responses strictly to **Executive Summaries**. Offload **all code snippets, URLs, configuration details, and multi-step procedures into Markdown artifacts (`.md`)**.

---

## 1. Volume & Sizing Targets (Ultra-Compact)

| Metric | 🎯 Standard Target (Recommended) | ⚠️ Hard Ceiling (Absolute Maximum) |
| :--- | :--- | :--- |
| **Character Count** | **300 - 450 characters** | **Max 600 characters** (including markdown syntax) |
| **Line Count** | **8 - 12 lines** (including blank lines) | **Max 15 lines** (including blank lines) |
| **Structure** | 1-2 sentence conclusion + 3-4 bullet points + artifact link + next action pill | Avoid headers (`#`), code blocks (` ``` `), and horizontal rules (`---`) in chat body |

> [!NOTE]
> Maintain the user's conversation language (e.g. Japanese) when writing the chat response, but adhere strictly to these compact sizing bounds.

---

## 2. Artifact-First Triage Rules (Offload Immediately)

Move the following items **out of chat text and into an artifact**:
* **Code / Scripts / Commands**: Any snippet >= 3 lines, or complex one-liners.
* **URLs / API Endpoints**: Long URLs with query params, documentation links.
* **Concrete Parameters / Config**: IP lists, CIDRs, ports, full setting schemas.
* **Detailed Procedures**: Multi-step workflows or troubleshooting walk-throughs (>= 3 steps).

### Permitted in Chat Body (Summary Only)
* Core conclusion / policy (1-2 sentences).
* Key highlights / decisions (3 bullet points, 1 line each).
* Clickable file link to the generated artifact.
* **Next Action Pill**: A single concise line suggesting the immediate next step (e.g. `👉 Next Action: ...` or localized equivalent).

---

## 3. Formatting Example (Zero Scroll)

```markdown
Optimal IP routing maintenance is designed around **(1) automated BGP sync**, **(2) supernetting CIDRs**, and **(3) runtime socket detection**.

* **Automated BGP Sync**: Fetch official prefix updates via public ASN REST API on a periodic cadence.
* **Aggregated Supernetting**: Configure client routing rules with summary CIDRs to minimize route churn.
* **Socket Anomaly Detection**: Audit socket connections against local routing tables via PowerShell.

Detailed design specs, CIDR tables, and detection scripts are documented below.
👉 Detailed Design: [network-route-maintenance.md](file:///path/to/network-route-maintenance.md)
💡 Next Action: Run PowerShell script verification or review CIDR allocation table.

> 🧭 [Direct: Flash]
```
