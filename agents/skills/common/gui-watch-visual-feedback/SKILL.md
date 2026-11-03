---
name: gui-watch-visual-feedback
description: >-
  Work with GUI applications in a fast visual feedback loop. Use whenever developing,
  refining, or styling GUI apps (e.g. Rust/Win32/Tauri/Flutter/Electron/Web overlays)
  where an external shell runs the app in watch/hot-reload mode (such as `cargo watch -x run`)
  and the agent autonomously captures and inspects rendered UI via screenshots to iteratively
  adjust margins, typography, layout, and visual appearance without manual user intervention.
---

# GUI Watch & Autonomous Visual Feedback Workflow

This skill defines the autonomous feedback loop procedure for developing and refining Desktop/GUI applications using hot-reload / watch mode and autonomous visual inspection.

## 1. Prerequisites & Environment Setup

1. **Watch Mode in External Shell**:
   - The user or external shell runs the target application in watch/hot-reload mode (e.g., `cargo watch -x run` for Rust projects).
   - Whenever source code is edited and saved, the process is automatically recompiled and restarted.

2. **Offscreen / Render Snapshot Capability**:
   - The GUI engine or overlay should support saving its rendered pixmap/frame to a known scratch path (e.g., `<scratch_dir>/hud_rendered.png` or an OS screenshot).
   - This ensures 100% deterministic, high-resolution visual capture regardless of window layering, transparency (`WS_EX_LAYERED`), or session isolation.

## 2. The Autonomous Iteration Cycle

When tasked with adjusting layout, typography, margins, padding, colors, or visual hierarchy:

```
[ Code Edit & Save ]
        │
        ▼
[ Watch Recompile & Auto-Restart ]
        │  (Wait ~1000-1500ms for recompilation & initial render)
        ▼
[ Frame Snapshot Generated ]
        │
        ▼
[ view_file on Snapshot PNG ]
        │  (Multimodal visual inspection of layout & text clearance)
        ▼
[ Evaluate & Adjust Parameters ]
        │
        └─── Repeat until visually balanced
```

## 3. Best Practices for Visual Quality

- **Text & UI Clearances**:
  - Never allow text baselines or descenders to collide with progress tracks, borders, or hubs.
  - When in doubt, ensure at least 6–10px of visible breathing room between text labels and circular/arc boundaries.
- **Section Headers & Hierarchy**:
  - Center section headers relative to the panel width (`w / 2.0`) to provide bilateral symmetry for multi-column or dual meters.
  - Distribute meter centers symmetrically (`w / 2 - offset`, `w / 2 + offset`).
- **Aspect Ratio & Compactness**:
  - Keep HUD overlays as compact as possible while preserving comfortable padding to minimize desktop screen footprint.
