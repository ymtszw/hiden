---
name: windows-terminal-guidelines
description: >-
  Guidelines, safety practices, and command conventions for running terminal tasks and CLI processes on Windows (PowerShell/cmd) within Antigravity.
  Use whenever executing shell commands, building code, running tests, invoking git/npm/cargo, launching dev servers,
  or diagnosing stuck, hanging, or non-responsive terminal tasks on Windows.
---

# Windows Terminal Execution Guidelines for Antigravity

On Windows environments, terminal commands executed via Antigravity's `run_command` tool run under **PowerShell** by default. Because of Windows process models and pseudoconsole (ConPTY) stream management, interactive prompts, continuation mode (`>>`), unclosed standard input handles, or lingering child processes can cause terminal tasks to hang indefinitely.

Follow these strict guidelines when planning or executing terminal commands on Windows.

---

## 1. Eliminate Interactive Prompts & Pagers (STDIN Hangs)

Never allow a command to invoke an interactive pager or prompt for user confirmation (`y/N`).

### Git Commands
Always append `--no-pager` even if `core.pager` is set to `cat`:
```powershell
# Safe Git execution
git --no-pager diff
git --no-pager log -n 10 --oneline
git --no-pager status -s
git --no-pager branch -a
git --no-pager show
```

### Package Managers & CLI Tools
Always pass non-interactive confirmation flags:
```powershell
# npm / npx / pnpm
npm install --yes
npx -y <package-name>
pnpm add --yes

# PowerShell cmdlets
Remove-Item -Recurse -Force <path>
Stop-Process -Name <process> -Force -Confirm:$false
```

### Preventing STDIN Blocks & Continuation Mode (`>>` Hangs)
* **Never feed unclosed quotes or multiline strings** directly into the terminal string. An unclosed bracket, quote, or pipe triggers PowerShell continuation mode (`>>`), causing the agent to wait indefinitely.
* **Redirect input from `$null`** if a command might prompt for confirmation when piped or without a TTY:
  ```powershell
  $null | <command>
  ```
* When launching external PowerShell sub-processes, always enforce non-interactive execution:
  ```powershell
  powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "..."
  ```

---

## 2. Managing Output Volume & Long-Running Processes

### Decoupling Large Output Streams (Avoid ConPTY Pipe-Lock)
ConPTY merges stdout/stderr into a single buffer. When running verbose builds or large test suites (e.g. `cargo test`, `npm test`, `dotnet build`), dumping thousands of lines directly to the console can saturate ConPTY streams and trigger timeout desyncs.
* **Best Practice**: Redirect heavy outputs to a scratch log file, then inspect it with `read_file`:
  ```powershell
  cargo test *>&1 | Out-File -Encoding utf8 -FilePath "<scratch_dir>/test.log"
  ```

### Background Daemons & Dev Servers
Background servers, watch commands, and dev servers (`vite`, `cargo watch`, `npm run dev`) must never be run as synchronous blocking commands.

When calling `run_command`:
1. Set `IsDaemon: true`.
2. Set `WaitMsBeforeAsync: 500` (or at most `1000`).
3. Set a clear `toolSummary` such as `"Dev server startup"`.

Do **NOT** use `sleep` or wait loops in shell commands to wait for processes.

---

## 3. Child Process Pipe Handle Leakage (Orphan Processes)

On Windows, Node.js / ConPTY will not trigger the stream `close` event if an orphan child process inherits and holds open standard output (`STDOUT`) or standard error (`STDERR`).

- When spawning sub-tools that spin off background workers, ensure they do not inherit active pipes without decoupling.
- To run independent background jobs in PowerShell, use:
  ```powershell
  Start-Process -FilePath "<executable>" -ArgumentList "<args>" -NoNewWindow
  ```

---

## 4. Recovering from Stuck Tasks & Zombie Processes

If a task stops responding or locks a TCP port / file:

1. **Identify the Task/PID**:
   ```powershell
   # Find process locking a specific port (e.g., 3000, 8080)
   Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue | Select-Object OwningProcess, State
   ```

2. **Terminate the Process Tree**:
   ```powershell
   # Force kill by PID
   taskkill /F /T /PID <PID>

   # Or kill by executable name
   Stop-Process -Name "node" -Force -ErrorAction SilentlyContinue
   Stop-Process -Name "git" -Force -ErrorAction SilentlyContinue
   ```

3. **Manage Antigravity Tasks**:
   - Check active tasks with `manage_task` (Action: `'list'`).
   - If a background task is unresponsive, terminate it with `manage_task` (Action: `'kill'`, TaskId: `...`).
