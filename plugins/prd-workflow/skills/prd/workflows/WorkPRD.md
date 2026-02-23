# WorkPRD Workflow
# Implements defined tasks from a PRD

## Prerequisites

Before starting, verify:

1. **Identify the PRD**
   - If not specified, list available PRDs with `scripts/list-prds.sh`
   - Confirm which PRD to work on

2. **Check Readiness**
   - Run `scripts/task-status.sh <prd-name>`
   - Verify: `draft` count is 0 and `defined` count is > 0
   - If tasks are still in draft, suggest running PlanPRD first

3. **Verify Prerequisites**
   - Research is complete (check `scripts/research-status.sh`)
   - All discussion questions are answered
   - PRD is self-contained with all necessary context

## Steps

### Step 1: Implement Task Plans

Get defined tasks with `scripts/list-defined-tasks.sh <prd-name>`

**Execution order**:
- Top-level tasks: Execute **sequentially**
- Subtasks within a parent: Execute **in parallel** when possible

For each defined task:
1. Get full task details with `scripts/get-task.sh <prd> <task-name>`
2. Launch `prd-worker` subagent with the spec path
3. Wait for completion
4. Update task status: `scripts/update-task-status.sh <prd> <task> completed`
5. Log the completion in `log.md`

**Handling blockers**:
- If a task returns `status: blocked`, document the blocker
- Continue with other tasks that don't depend on the blocked one
- Report blockers at the end

### Step 2: Update Documentation

After implementation, update relevant documentation:

- README files (if functionality changed)
- API documentation (if endpoints added/modified)
- Inline code comments (following codebase style)
- Configuration documentation (if config changed)
- Usage examples (if behavior changed)

**Documentation principle**: Focus on the **Why** and intent, not the **What** - code shows what it does, documentation explains why.

### Step 3: Report Results

Provide a comprehensive summary:

```markdown
## PRD Implementation Summary: [prd-name]

### Tasks Completed
- [x] Task 1 name
- [x] Task 2 name
- [ ] Task 3 name (blocked)

### Files Affected
- `path/to/file1.ts` - Created: [description]
- `path/to/file2.ts` - Modified: [description]

### Key Decisions
- [Decision 1 and rationale]
- [Decision 2 and rationale]

### Blockers Requiring Attention
- [Blocker description and what's needed to resolve]

### Next Steps
- [Any follow-up actions needed]
```

## Implementation Log

Maintain a log at `.claude/prds/<prd-name>/log.md`:

```markdown
# Implementation Log

## [ISO 8601 timestamp] - [Task Name]

**Status**: Completed

**Summary**: Brief description of what was implemented

**Changes Made**:
- `path/to/file.ts` - Created/Modified/Deleted: description

**Notes**: Any relevant context or decisions made
```

New entries go at the **top** (reverse chronological order).

## Core Principles

1. **Stay Focused**: Only implement what's in the spec
2. **Respect Constraints**: Follow technical requirements strictly
3. **Test Thoroughly**: Verify all acceptance criteria
4. **Handle Blockers**: Document, don't force through
5. **Verify Dependencies**: Ensure prerequisite tasks are complete
6. **Understand Context**: Read surrounding code before modifying
7. **Document Progress**: Keep the log updated in real-time

## Error Recovery

If a task fails:
1. Capture the error details
2. Check if it's a dependency issue
3. Check if prerequisites were missed
4. Document in the log with full context
5. Report to user with suggested resolution

Never mark a task complete if:
- Tests are failing
- Implementation is partial
- Acceptance criteria aren't met
- Blockers remain unresolved
