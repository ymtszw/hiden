# Windows Environment Guidelines

Applicable to native Windows environments (PowerShell / Command Prompt).

## Environment & Tooling
- **Shell**: PowerShell (Core / 7+ or Windows PowerShell 5.1). Use idiomatic PowerShell cmdlets where appropriate (`Get-ChildItem`, `Test-Path`, etc.) or explicitly call standard cross-platform tools.
- **Path Handling**: Handle both backslashes (`\`) and forward slashes (`/`) gracefully. Watch out for escape characters (`\` vs `` ` `` in PowerShell).
- **Encoding & Line Endings**:
  - Prefer UTF-8 without BOM unless specifically required by legacy Windows tools.
  - Be mindful of CRLF vs LF differences when touching repository files.
- **Execution Policy & Permissions**:
  - Keep ExecutionPolicy restrictions in mind (`-ExecutionPolicy Bypass` or `RemoteSigned`).
  - Do not assume symlinks can be created without Administrator privileges or Windows Developer Mode enabled (prefer file copies or junction points if symlinks fail).
