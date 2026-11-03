---
name: win-process-ports
description: >-
  Use this skill in Windows environments (PowerShell) to inspect port bindings,
  running services, or kill stuck processes.
---

# Windows Process & Port Management (PowerShell)

## Port Inspection
- Find process ID (PID) using a port (e.g. 8080):
  ```powershell
  Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue | Select-Object LocalAddress, LocalPort, State, OwningProcess
  ```

## Process Inspection & Termination
- Get process details by PID:
  ```powershell
  Get-Process -Id <PID>
  ```
- Terminate process gracefully or forcefully:
  ```powershell
  Stop-Process -Id <PID> -Force
  ```
