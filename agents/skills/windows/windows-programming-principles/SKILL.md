---
name: windows-programming-principles
description: >-
  Principles and rules for writing programs, scripts, PoCs, and managing projects on this Windows machine.
  Use whenever planning or writing code, choosing languages/runtimes (PowerShell first, then Node.js/JavaScript, strictly avoiding Python on Windows),
  using mise/direnv, or promoting scratch code to a Git-versioned project.
---

# Windows Programming & Project Principles

Standard engineering principles for programming, scripting, PoCs, investigations, and project setup on this Windows machine. Follow these to prevent environment pollution, encoding issues, and maintainability degradation.

---

## 1. Language & Runtime Selection Hierarchy

### ① First Choice: PowerShell First
* **Scope**: PoCs, small-scale investigations, file manipulation, system automation, lightweight data conversions, CLI invocations.
* **Rationale**: Native to Windows with zero installation overhead. Excels at object pipeline processing.
* **Guidelines**:
  - Always evaluate whether a problem can be solved in PowerShell (`.ps1` scripts or inline commands) before adding external runtimes.
  - Follow `windows-terminal-guidelines` strictly to avoid hanging on interactive prompts.

### ② Second Choice: Node.js & JavaScript (When PowerShell is Insufficient)
* **Scope**: Complex data processing, asynchronous workflows, web scraping, API integrations, or leveraging the npm ecosystem.
* **Guidelines**:
  - Use Node.js/JavaScript as the primary alternative whenever PowerShell syntax becomes too verbose or underpowered.
  - `mise` and `direnv` are installed globally via `winget`. Use the global Node.js runtime provided by `mise`.

### ③ Strictly Prohibited: Avoid Python on Windows (Zero Python)
* **Core Rule**: **Never use bare-metal, uncontainerized Python on this Windows machine.**
* **Rationale**:
  - Uncontainerized Python on Windows has notoriously fragile hygiene.
  - Frequent pitfalls: multiple colliding versions, `PATH` pollution, virtual environment (`venv`) symlink/path failures, character encoding mismatches (`cp932` vs `UTF-8`), and native C++ Build Tools compilation errors.
* **Remediation**:
  - Any task typically considered for Python must be implemented in **PowerShell** or **Node.js / JavaScript**.

---

## 2. Environment & Toolchain Management (mise & direnv)

* **Global Setup**:
  - `mise` and `direnv` are globally installed via `winget`.
  - For scratch scripts and temporary investigations, invoke global tools (`node`, `npm`, `npx`) managed by `mise`.
* **Tool Installation**:
  - When additional CLI tools or language runtimes are required, install and manage them via `mise` rather than standalone OS installers.

---

## 3. Transitioning Scratch Code to a Git-Versioned Project

Once scratch exploration or PoC code is deemed worthy of ongoing maintenance, immediately transition it into a formal project:

### Step 1: Establish Workspace Directory
* Move the code from the scratch/temp directory into a dedicated project workspace directory.

### Step 2: Git Repository Initialization & Frequent Commits
* Initialize repository:
  ```powershell
  git init
  ```
* Add an appropriate `.gitignore` (excluding `node_modules/`, `.env`, temporary logs, and build artifacts).
* Commit incrementally with atomic, descriptive messages to maintain diff traceability.

### Step 3: Toolchain Pinning with mise
* Pin tool versions inside the project root:
  ```powershell
  mise use node@<version>
  ```
  or configure `.mise.toml`.

### Step 4: Environment Variables via direnv (Optional)
* For project-specific environment variables or path overrides, configure `.envrc` and execute `direnv allow`.
