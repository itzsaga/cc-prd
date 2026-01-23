# Task Specification Template
# Structure for detailed task specification files

Each task without subtasks in `tasks.yaml` must have an associated spec file that follows this structure. The spec file provides detailed context for the subagent completing the task.

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

## Testing Requirements

<How should the subagent verify their implementation is correct?>

- [ ] Test requirement 1
- [ ] Test requirement 2

## Out of Scope

<Explicitly list what this task should NOT do to prevent scope creep.>

- Item 1
- Item 2
```

## Rules

- Spec files are stored in the PRD's `specs/` directory
- Acceptance criteria must be verifiable and specific
- Code references should include concrete file paths and line numbers
- Keep specs thorough but focused - detail for implementation without over-specification
- Out of Scope section is critical for preventing scope creep
