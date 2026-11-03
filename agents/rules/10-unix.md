# Unix / POSIX Environment Guidelines

Applicable to macOS, Linux, and WSL environments.

---

## 1. Terminal Execution & Safety
- **Shell**: Prefer POSIX / bash / zsh / fish compatible idioms. Default interactive shell on macOS may be zsh or fish.
- **Paging & Prompts**: Always pass `--no-pager` for git and non-interactive flags (`-y`, `--yes`) to prevent hanging prompts.
- **Line Endings & Encoding**: Enforce LF line endings (`\n`) and UTF-8 encoding.
- **Output Decoupling**: For heavy test or build outputs, redirect output to a log file (`make test > test.log 2>&1`) to avoid buffer choking.

---

## 2. Programming Principles & Tooling
- **Language Hierarchy**:
  1. **Shell Scripts (POSIX / bash)**: For system orchestration, light automation, and CLI wiring (`set -euo pipefail`).
  2. **Node.js / TypeScript / Go / Rust**: For complex applications and services. Manage runtimes via `mise` or `asdf`.
  3. **Python (Virtual Environments Only)**: If Python is used, strictly require virtual environments (`uv`, `venv`, `poetry`)—never install packages into system Python.
- **Modern CLI Tools**: Leverage modern Unix tools when available (`ripgrep` / `rg`, `fd`, `jq`, `mise`, `pnpm`).

---

## 3. Filesystem & Link Handling
- **Symlinks**: Use standard relative or absolute symbolic links (`ln -sf` for files, `ln -sfn` for directories).
