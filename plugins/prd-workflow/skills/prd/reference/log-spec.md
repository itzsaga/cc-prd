# Implementation Log Specification
# Defines the structure for tracking completed work

## Overview

The implementation log is a markdown file that documents completed work for a PRD. It lives at `.claude/prds/[prd_name]/log.md`.

## Structure

New entries go at the **top** of the file (reverse chronological order).

```markdown
# Implementation Log

## [ISO 8601 Timestamp] - [Task Name]

**Status**: Completed | Blocked

**Summary**: Brief description of what was implemented or why it's blocked.

**Changes Made**:
- `path/to/file.ts` - Created: Description
- `path/to/other.ts` - Modified: Description
- `path/to/old.ts` - Deleted: Description

**Notes**: Any relevant context, decisions made, or deviations from the spec.

---

## [Earlier Timestamp] - [Earlier Task Name]

...
```

## Required Fields

### Timestamp
- Use ISO 8601 format: `YYYY-MM-DDTHH:MM:SS`
- Example: `2024-01-15T14:30:00`

### Task Name
- Must match the task name in `tasks.yaml`

### Status
- `Completed` - Task finished successfully
- `Blocked` - Task could not be completed, requires attention

### Summary
- One to two sentences describing what was accomplished
- For blocked tasks, explain what prevented completion

### Changes Made
- List **every file** that was created, modified, or deleted
- Include brief description of each change
- Use consistent action labels: Created, Modified, Deleted

### Notes
- Document any decisions made during implementation
- Note any deviations from the spec and why
- Include relevant context for future reference

## Example Entry

```markdown
## 2024-01-15T14:30:00 - Implement user authentication middleware

**Status**: Completed

**Summary**: Created JWT-based authentication middleware with role-based access control.

**Changes Made**:
- `src/middleware/auth.ts` - Created: Main authentication middleware
- `src/types/auth.ts` - Created: Type definitions for auth tokens
- `src/config/auth.ts` - Modified: Added JWT secret configuration
- `tests/middleware/auth.test.ts` - Created: Unit tests for auth middleware

**Notes**: Chose HS256 algorithm for JWT signing as specified in constraints. Added rate limiting on token refresh endpoint as a security measure (not in original spec but aligns with security constraints).
```

## Best Practices

1. **Log immediately** - Create entries as soon as tasks complete, not in batches

2. **Be specific** - Vague entries are not useful for debugging or understanding history

3. **Document decisions** - Future you (or other developers) will thank you

4. **Track blocked items** - Don't just skip them, document why they're blocked
