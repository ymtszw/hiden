# Unix / POSIX Environment Guidelines

Applicable to macOS, Linux, and WSL environments.

## Environment & Tooling
- **Shell**: Prefer POSIX / bash / zsh / fish compatible idioms. Default interactive shell on macOS may be fish or zsh.
- **Line Endings & Encoding**: Always enforce LF line endings (`\n`) and UTF-8 encoding.
- **Path Separators**: Use forward slashes (`/`) for all paths.
- **Tooling Preferences**:
  - Prefer modern CLI tools when available (`ripgrep` / `rg`, `fd`, `jq`, `mise`, `uv`, `pnpm`).
  - Shell scripts should include `set -euo pipefail` where appropriate.
