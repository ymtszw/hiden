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
* **Next Action Pill**: A single concise line suggesting the immediate next step (e.g. `👉 次のアクション: ...`).

---

## 3. Formatting Example (Zero Scroll)

```markdown
BlizzardのIP追従は **(1) BGP自動同期**, **(2) 集約CIDR指定**, **(3) 接続時検知** の3軸で設計するのが最適です。

* **BGP APIによる自動追跡**: 公式AS番号からAPI経由で最新CIDRを自動差分取得
* **集約指定（Supernetting）**: クライアント側は上位CIDRを指定し配布頻度をゼロ化
* **未知IPの漏れ検知**: ソケット接続先とルーティング表を照合するPowerShell検知

詳細仕様書、CIDR表、検知スクリプトは以下にまとめました。
👉 詳細設計書: [blizzard-route-maintenance.md](file:///path/to/blizzard-route-maintenance.md)
💡 次の推奨アクション: 「PowerShellスクリプトの実機テスト」または「CIDR一覧の確認」

> 🧭 [Direct: Flash]
```
