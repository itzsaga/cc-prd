# CLI Tools
# Reference documentation for PRD workflow CLI tools

The following CLI tools are available across all workflows.

## PRD Management

### `claude-PRD-list-prds`

Lists all PRDs with their status. Returns JSON output.

```bash
claude-PRD-list-prds
# Output: [{"name": "my-feature", "status": "in-progress", "completed": 3, "total": 5}, ...]
```

**Statuses**:
- `draft` - No tasks completed
- `in-progress` - At least one but not all tasks completed
- `complete` - All tasks completed
- `no-tasks` - No tasks.yaml or no tasks defined

## Task Management

### `claude-PRD-task-status <prd-name>`

Returns JSON describing task counts by status for a specific PRD.

```bash
claude-PRD-task-status my-feature
# Output: {"draft": 2, "defined": 3, "completed": 1, "total": 6}
```

### `claude-PRD-get-task <prd-name> <task-name>`

Returns full task details including status, spec path, and file locations.

```bash
claude-PRD-get-task my-feature "Implement API endpoint"
# Output:
# {
#   "name": "Implement API endpoint",
#   "description": "Create the login endpoint",
#   "status": "defined",
#   "spec": "specs/implement-api-endpoint.md",
#   "spec_path": ".claude/prds/my-feature/specs/implement-api-endpoint.md",
#   "spec_exists": true,
#   "parent": null,
#   "prd_name": "my-feature",
#   "prd_path": ".claude/prds/my-feature/PRD.md",
#   "log_path": ".claude/prds/my-feature/log.md",
#   "log_exists": true,
#   "found": true
# }
```

### `claude-PRD-list-draft-tasks <prd-name>`

Lists all leaf tasks (tasks without subtasks) that are in draft status.

```bash
claude-PRD-list-draft-tasks my-feature
# Output: [{"name": "Implement API endpoint", "description": "...", "spec": "specs/implement-api-endpoint.md", "parent": null}, ...]
```

### `claude-PRD-list-defined-tasks <prd-name>`

Lists all tasks with `defined` status that are ready for implementation.

```bash
claude-PRD-list-defined-tasks my-feature
# Output: [{"name": "Implement API endpoint", "description": "...", "spec": "specs/implement-api-endpoint.md", "parent": null}, ...]
```

### `claude-PRD-update-task-status <prd-name> <task-name> <new-status>`

Updates the status of a specific task.

```bash
claude-PRD-update-task-status my-feature "Implement API endpoint" completed
# Valid statuses: draft, defined, completed
```

## Research Management

### `claude-PRD-research-status <prd-name>`

Returns JSON describing research question status for a specific PRD.

```bash
claude-PRD-research-status my-feature
# Output: {"draft": 1, "complete": 4, "total": 5}
```

### `claude-PRD-get-unanswered-research <prd-name>`

Returns JSON array of unanswered research questions (those without an `answer` field).

```bash
claude-PRD-get-unanswered-research my-feature
# Output: [{"text": "What library should we use for auth?", "mode": "answer"}, ...]
```

Each question includes:
- `text` - The research question
- `mode` - Either `answer` (quick search) or `deep-research` (comprehensive analysis)
