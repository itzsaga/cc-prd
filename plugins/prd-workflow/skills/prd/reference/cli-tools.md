# Scripts
# Reference documentation for PRD workflow scripts

The following scripts are available in the `scripts/` directory relative to the skill root. All paths below are relative to the skill directory.

## PRD Management

### `scripts/list-prds.sh`

Lists all PRDs with their status. Returns JSON output.

```bash
scripts/list-prds.sh
# Output: [{"name": "my-feature", "status": "in-progress", "completed": 3, "total": 5}, ...]
```

**Statuses**:
- `draft` - No tasks completed
- `in-progress` - At least one but not all tasks completed
- `complete` - All tasks completed
- `no-tasks` - No tasks.yaml or no tasks defined

## Task Management

### `scripts/task-status.sh <prd-name>`

Returns JSON describing task counts by status for a specific PRD.

```bash
scripts/task-status.sh my-feature
# Output: {"draft": 2, "defined": 3, "completed": 1, "total": 6}
```

### `scripts/get-task.sh <prd-name> <task-name>`

Returns full task details including status, spec path, and file locations.

```bash
scripts/get-task.sh my-feature "Implement API endpoint"
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

### `scripts/list-prd-draft-tasks.sh <prd-name>`

Lists all leaf tasks (tasks without subtasks) that are in draft status.

```bash
scripts/list-prd-draft-tasks.sh my-feature
# Output: [{"name": "Implement API endpoint", "description": "...", "spec": "specs/implement-api-endpoint.md", "parent": null}, ...]
```

### `scripts/list-defined-tasks.sh <prd-name>`

Lists all tasks with `defined` status that are ready for implementation.

```bash
scripts/list-defined-tasks.sh my-feature
# Output: [{"name": "Implement API endpoint", "description": "...", "spec": "specs/implement-api-endpoint.md", "parent": null}, ...]
```

### `scripts/update-task-status.sh <prd-name> <task-name> <new-status>`

Updates the status of a specific task.

```bash
scripts/update-task-status.sh my-feature "Implement API endpoint" completed
# Valid statuses: draft, defined, completed
```

## Research Management

### `scripts/research-status.sh <prd-name>`

Returns JSON describing research question status for a specific PRD.

```bash
scripts/research-status.sh my-feature
# Output: {"draft": 1, "complete": 4, "total": 5}
```

### `scripts/get-unanswered-research.sh <prd-name>`

Returns JSON array of unanswered research questions (those without an `answer` field).

```bash
scripts/get-unanswered-research.sh my-feature
# Output: [{"text": "What library should we use for auth?", "mode": "answer"}, ...]
```

Each question includes:
- `text` - The research question
- `mode` - Either `answer` (quick search) or `deep-research` (comprehensive analysis)
