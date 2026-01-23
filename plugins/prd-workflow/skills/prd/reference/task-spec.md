# Task Specification Template
# Defines the structure for task specification files

## Overview

Each task without subtasks in `tasks.yaml` must have an associated spec file. The spec file provides detailed context for the subagent completing the task.

Spec files are stored in the PRD's `specs/` directory.

## Template

```markdown
# [Task Name]

## Objective

<A clear, actionable statement of what this task should accomplish. Be specific about the expected outcome.>

## Context

<Background information the subagent needs to understand why this task exists and how it fits into the larger PRD objective.>

### Parent PRD

- **PRD**: [PRD Name]
- **PRD Path**: `.claude/prds/[prd_name]/PRD.md`

### Related Tasks

<List any tasks that this task depends on or that depend on this task.>

- **Depends on**: [Task name(s) that must be completed before this task]
- **Blocks**: [Task name(s) that cannot start until this task is complete]

## Acceptance Criteria

<A checklist of specific, measurable criteria that define when this task is complete.>

- [ ] Criterion 1: <Specific, verifiable condition>
- [ ] Criterion 2: <Specific, verifiable condition>
- [ ] Criterion 3: <Specific, verifiable condition>

## Implementation Notes

### Files to Modify

<List files that will need to be created, modified, or deleted.>

| File Path | Action | Description |
|-----------|--------|-------------|
| `path/to/file.ext` | Create/Edit/Delete | Brief description of changes |

### Technical Constraints

<Any technical requirements, limitations, or patterns that must be followed.>

- Constraint 1
- Constraint 2

### Relevant Code References

<Pointers to existing code that the subagent should review or use as reference.>

- `path/to/file.ext:line_number` - Description of what this code does
- `path/to/another/file.ext` - Description of relevance

### Code Examples

<Optional code snippets showing expected patterns, function signatures, or usage examples.>

\`\`\`language
// Example showing expected implementation pattern or API usage
\`\`\`

## Testing Requirements

<How should the subagent verify their implementation is correct?>

- [ ] Test requirement 1
- [ ] Test requirement 2

## Out of Scope

<Explicitly list what this task should NOT do to prevent scope creep.>

- Item 1
- Item 2
```

## Guidelines

1. **Acceptance criteria must be verifiable and specific** - A subagent should be able to definitively determine if each criterion is met

2. **Code references should be concrete** - Include file paths and line numbers when possible

3. **Keep specs thorough but focused** - Provide enough detail for implementation without over-specifying

4. **Out of Scope is critical** - Explicitly defining boundaries prevents scope creep

5. **Testing requirements enable verification** - Include how to validate the implementation works
