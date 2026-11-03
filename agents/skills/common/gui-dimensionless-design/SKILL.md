---
name: gui-dimensionless-design
description: >-
  Apply dimensionless scale design principles for GUI spacing, margins, padding, and typography.
  Use whenever designing, refining, styling, or reviewing user interfaces across any platform
  (Rust/Win32/egui/Slint, Web/HTML/CSS, Flutter, React/React Native, Tauri, etc.) to calculate
  responsive spacing scales from Base_Space, typography scales from Base_Text, line heights,
  and element relationships without hardcoding absolute pixels.
---

# GUI Design: Dimensionless Token System (Spacing & Typography)

This skill provides a platform-agnostic, dimensionless design system for user interfaces.
All sizes, margins, paddings, and typography must derive from two dimensionless base tokens (`Base_Space` and `Base_Text`) rather than hardcoded absolute units (px, dp, pt).

---

## 1. Base Tokens Definition

All dimensions and typography are calculated as multipliers relative to two base tokens (scale = 1.0):

* **`Base_Space` (Spacing Base)**:
  * Default layout interval.
  * Adjusts according to UI density settings:
    * *Compact*: e.g., 6px ~ 8px (dashboards, dense data tools, overlays)
    * *Comfortable*: e.g., 10px ~ 12px (content applications, broad forms)
* **`Base_Text` (Typography Base)**:
  * Default body text size.
  * Adjusts according to system font preferences, DPI scale, and accessibility zoom (e.g., 12px ~ 14px).

---

## 2. Spacing Scale (Relative to `Base_Space`)

All layout margins, paddings, and gaps must strictly follow the multiplier scale:

| Multiplier | Scale Name | Intent / Use Case | Typical Examples |
|---|---|---|---|
| **`0.25x`** (`Base_Space * 0.25`) | X-Small | Micro spacing | Icon-to-text gap, badge/tag internal padding |
| **`0.5x`** (`Base_Space * 0.5`) | Small | Structural cohesive set | Title-to-subtitle, tightly coupled elements within a card |
| **`1.0x`** (`Base_Space * 1.0`) | Medium | Standard interval | Control internal padding, list item gaps, paragraph margin |
| **`1.5x`** (`Base_Space * 1.5`) | Large | Component partition | Panel/card internal padding, gaps between distinct groups |
| **`2.0x`** (`Base_Space * 2.0`) | X-Large | Section boundary | Margins between major content blocks and view sections |
| **`3.0x` / `4.0x`** | XX-Large | Major partition | Welcome/hero layouts, broad gaps across decoupled views |

---

## 3. Typography Scale (Relative to `Base_Text`)

### ① Font Size Factors

Font sizes are calculated strictly relative to `Base_Text`:

| Level | Size Factor | Weight | Role & Usage |
|---|---|---|---|
| **H1** (View Title) | `1.5x` ~ `2.0x` | Bold / Heavy | Top-level view or screen title |
| **H2** (Section Title) | `1.25x` | SemiBold / Bold | Section header for panels and card groups |
| **Body** (Standard Text) | `1.0x` | Regular / Medium | Body copy, control labels, numeric readouts |
| **Caption** (Property Label) | `0.75x` ~ `0.85x` | Regular / Medium | Meter labels, auxiliary info, timestamps, tooltips |

### ② Line Height Factor (Relative to Own Font Size)

Line height is a dimensionless multiplier relative to each text element's *own font size*:

* **Body (`1.5` ~ `1.7`)**: Spacious line height to preserve comfortable multi-line reading.
* **Heading (`1.2` ~ `1.3`)**: Compact line height to prevent large heading lines from appearing detached.

### ③ Line Length Constraint (Reading Width)

* Multi-line text containers must constrain maximum width to **35ch ~ 40ch** (`max-width: 40ch`) to reduce ocular tracking fatigue.

---

## 4. Spacing × Typography Relationship Rules

Proximity principles (Gestalt psychology) governing visual grouping:

```text
[ Previous Section / Content ]
       │
       ▼ Margin: 2.0x (Base_Space * 2.0)  <-- Clear boundary signaling context transition
[ Next Section Heading (Heading) ]
       │
       ▼ Margin: 0.5x (Base_Space * 0.5)  <-- Tight cohesion forming a single structural set
[ Body Copy / Content (Body) ]
       │
       ▼ Margin: 1.0x (Base_Space * 1.0)  <-- Standard gap preserving paragraph independence
[ Next Paragraph (Body) ]
```

| Element Pair | Recommended Margin / Gap | Design Intent |
|---|---|---|
| **Heading** & Immediate Child | `0.5x` (`Base_Space * 0.5`) | Bind heading and content into a cohesive visual unit |
| **Paragraph** & Next Paragraph | `1.0x` (`Base_Space * 1.0`) | Exceed line height to define paragraph independence |
| **Previous Area** & Next Heading | `2.0x` (`Base_Space * 2.0`) | Distinct separation indicating change of topic/scope |

---

## 5. Agent Constraints & Implementation Patterns

### 🚨 Mandatory Agent Rules

1. **Zero Hardcoded Absolute Units**:
   Never output hardcoded numerical layout values (e.g., `padding: 16px`, `margin: 24`). Derive all layout metrics from token constants, structs, helper functions, or CSS variables.
2. **Preserve Proportional Ratios**:
   When adjusting for high-DPI scaling or UI density modes (Compact vs Comfortable), update only `Base_Space` and `Base_Text`. Keep multiplier ratios (0.25x, 0.5x, 1.0x, etc.) invariant.
3. **Prevent Hierarchy Inversions**:
   Outer margins must never be smaller than inner padding or line spacing (preventing Gestalt visual collapse).

---

### Implementation Examples by Platform

#### Rust (Native UI, Win32, tiny-skia, egui)

```rust
pub struct DesignTokens {
    pub base_space: f32,
    pub base_text: f32,
}

impl DesignTokens {
    pub const COMPACT: Self = Self { base_space: 8.0, base_text: 12.0 };
    pub const COMFORTABLE: Self = Self { base_space: 12.0, base_text: 14.0 };

    // Spacing scale
    #[inline] pub fn space_xs(&self) -> f32 { self.base_space * 0.25 }
    #[inline] pub fn space_sm(&self) -> f32 { self.base_space * 0.5 }
    #[inline] pub fn space_md(&self) -> f32 { self.base_space * 1.0 }
    #[inline] pub fn space_lg(&self) -> f32 { self.base_space * 1.5 }
    #[inline] pub fn space_xl(&self) -> f32 { self.base_space * 2.0 }

    // Typography scale
    #[inline] pub fn text_h1(&self) -> f32 { self.base_text * 1.75 }
    #[inline] pub fn text_h2(&self) -> f32 { self.base_text * 1.25 }
    #[inline] pub fn text_body(&self) -> f32 { self.base_text * 1.0 }
    #[inline] pub fn text_caption(&self) -> f32 { self.base_text * 0.8 }

    // Line heights
    #[inline] pub fn line_height_body(&self) -> f32 { self.text_body() * 1.6 }
    #[inline] pub fn line_height_heading(&self) -> f32 { self.text_h2() * 1.25 }
}
```

#### CSS / Web / Tauri

```css
:root {
  --base-space: 8px; /* Compact: 8px, Comfortable: 12px */
  --base-text: 13px;

  /* Spacing Scale */
  --space-xs: calc(var(--base-space) * 0.25);
  --space-sm: calc(var(--base-space) * 0.5);
  --space-md: calc(var(--base-space) * 1.0);
  --space-lg: calc(var(--base-space) * 1.5);
  --space-xl: calc(var(--base-space) * 2.0);

  /* Typography Scale */
  --text-h1: calc(var(--base-text) * 1.75);
  --text-h2: calc(var(--base-text) * 1.25);
  --text-body: calc(var(--base-text) * 1.0);
  --text-caption: calc(var(--base-text) * 0.8);

  /* Line Heights */
  --lh-body: 1.6;
  --lh-heading: 1.25;

  /* Line Length */
  --max-line-width: 40ch;
}
```
