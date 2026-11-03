# Windows Environment Guidelines

Applicable to native Windows environments (PowerShell / Command Prompt).

---

## 1. Windows Terminal Execution & ConPTY Safety
Terminal commands run under PowerShell. Prevent hangs and stream desyncs:
- **Prevent STDIN Hangs & Continuation Mode (`>>`)**:
  - Always pass `--no-pager` for all git commands.
  - Pass non-interactive flags (`npm install --yes`, `npx -y`, `pnpm add --yes`, `Remove-Item -Force`).
  - Never pipe raw unclosed quotes or multiline strings. Pipe `$null` if confirmation is possible (`$null | <command>`).
  - External sub-processes: `powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "..."`
- **Output Decoupling**: For large test/build logs, redirect output to a file and read via `read_file`:
  `cargo test *>&1 | Out-File -Encoding utf8 -FilePath "<scratch_dir>/test.log"`
- **Daemons**: Set `IsDaemon: true`, `WaitMsBeforeAsync: 500` for long-running servers (`vite`, `cargo watch`).

---

## 2. Programming Principles: Language Hierarchy & Hygiene
Maintain environment integrity on this host Windows environment:
- **Language Hierarchy**:
  1. **PowerShell First**: PoCs, small-scale surveys, system automation, simple transforms, CLI orchestration.
  2. **Node.js / JavaScript Second**: Complex async pipelines, web APIs, npm ecosystem (use global `mise` Node.js).
  3. **Strictly Avoid Python on Windows (Zero Python)**: Never use uncontainerized Python due to PATH pollution, venv symlinks, encoding mismatches (cp932/UTF-8), and native C++ build tool failures. Substitute with PowerShell or Node.js.
- **Tooling**: Manage CLI tools via `mise` (`direnv` for project `.envrc`). Use `git init` and atomic commits when promoting scratch code.

---

## 3. Filesystem & Link Handling
- **Encoding & Line Endings**: Prefer UTF-8 without BOM (`utf8NoBOM`). Preserve repository line endings.
- **Directory Junctions vs Symlinks**: Non-elevated Windows users lack symlink privileges by default. Use Directory Junctions (`New-Item -ItemType Junction`) for linking skill directories across tools, and `Copy-Item` for single files.
