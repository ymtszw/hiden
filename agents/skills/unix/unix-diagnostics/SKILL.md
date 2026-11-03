---
name: unix-diagnostics
description: >-
  Use this skill in Unix/macOS environments to diagnose system processes,
  port bindings, memory consumption, or disk usage issues.
---

# Unix Diagnostics Runbook

## Process & Port Inspection
- Find which process is listening on a given port (e.g. 8080):
  ```bash
  lsof -i :8080 -P -n
  ```
- Search for a specific running process:
  ```bash
  pgrep -fl <process_name>
  ```

## Disk & Memory Usage
- Check filesystem usage:
  ```bash
  df -h
  ```
- Find top directories consuming disk space:
  ```bash
  du -hd 1 . | sort -hr | head -n 10
  ```
