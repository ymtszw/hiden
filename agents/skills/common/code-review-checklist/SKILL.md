---
name: code-review-checklist
description: >-
  Use this skill when performing a code review, self-review before committing,
  or drafting review comments on a pull request.
---

# Code Review Checklist

Run through these verification dimensions systematically:

1. **Correctness & Edge Cases**:
   - Boundary values (empty list, null/undefined, 0, negative values).
   - Concurrency or async race conditions.
   - Resource leaks (unclosed sockets, handles, streams).

2. **Security & Input Validation**:
   - Are external inputs sanitized and validated?
   - Any accidental leakage of sensitive tokens, secrets, or PII into logs?

3. **Readability & Maintainability**:
   - Are variable and function names self-documenting?
   - Is logic split into small, single-responsibility units?

4. **Output Format**:
   - Group findings by severity: `[Critical]`, `[Warning]`, `[Nitpick]`.
   - Provide concrete code diffs or replacement snippets whenever proposing improvements.
