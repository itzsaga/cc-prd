# PRD Skill
# Manages Product Requirements Documents through their complete lifecycle

## Overview

The PRD skill handles the creation, planning, and implementation of Product Requirements Documents. It guides you through the appropriate workflow based on your intent.

## Invocation

When this skill is invoked, follow these steps:

1. **Reference the PRD specification** at `reference/prd-spec.md`
2. **Gather context** about existing PRDs using `claude-PRD-list-prds`
3. **Analyze the user's intent** from their request
4. **Route to the appropriate workflow**
5. **Execute the workflow**
6. **Report the outcome**

## Workflows

### CreatePRD

**When to use**: Creating a new PRD from scratch

**Trigger words**: "create", "new", "draft", "start", "begin"

**File**: `workflows/CreatePRD.md`

**Purpose**: Gather requirements and create a new PRD document structure

### PlanPRD

**When to use**: An existing PRD needs analysis, research, and task definition

**Trigger words**: "plan", "analyze", "research", "refine", "break down", "define tasks"

**File**: `workflows/PlanPRD.md`

**Purpose**: Analyze the PRD, conduct research, and create detailed task specifications

### WorkPRD

**When to use**: A PRD has defined tasks ready for implementation

**Trigger words**: "implement", "build", "execute", "work", "code", "develop"

**File**: `workflows/WorkPRD.md`

**Purpose**: Execute defined tasks and complete the implementation

## Decision Logic

```
Is the user creating new content?
├── Yes → CreatePRD
└── No → Does the PRD exist?
    ├── No → Ask for clarification or suggest CreatePRD
    └── Yes → Are tasks defined? (check with claude-PRD-task-status)
        ├── No tasks or all draft → PlanPRD
        └── Tasks defined (defined > 0) → WorkPRD
```

## CLI Tools

Use these tools to check PRD status:

- `claude-PRD-list-prds` - List all PRDs with status
- `claude-PRD-task-status <prd>` - Get task counts by status
- `claude-PRD-research-status <prd>` - Get research completion status

## References

- `reference/prd-spec.md` - PRD file format specification
- `reference/task-spec.md` - Task specification template
- `reference/cli-tools.md` - Full CLI tool documentation

## Ambiguity Handling

If the user's intent is unclear:
1. List available PRDs with their status
2. Ask which PRD they want to work with
3. Ask what action they want to take (create/plan/implement)

Never assume - always clarify when the routing decision is ambiguous.
