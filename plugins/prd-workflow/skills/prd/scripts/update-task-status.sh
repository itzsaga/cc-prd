#!/usr/bin/env bash
# Updates the status of a given task for a PRD

set -euo pipefail

# Check dependencies
if ! command -v yq &>/dev/null; then
    echo "Error: Required dependency (yq) not found" >&2
    exit 1
fi

usage() {
    echo "Usage: scripts/update-task-status.sh <prd-name> <task-name> <new-status>"
    echo ""
    echo "Updates the status of a task in a PRD's tasks.yaml file."
    echo ""
    echo "Arguments:"
    echo "  prd-name    Name of the PRD (directory name under .claude/prds/)"
    echo "  task-name   Name of the task to update"
    echo "  new-status  New status (draft, defined, or completed)"
    exit 1
}

if [[ $# -lt 3 ]]; then
    usage
fi

PRD_NAME="$1"
TASK_NAME="$2"
NEW_STATUS="$3"

TASKS_FILE=".claude/prds/${PRD_NAME}/tasks.yaml"

if [[ ! -f "$TASKS_FILE" ]]; then
    echo "Error: Tasks file not found: $TASKS_FILE" >&2
    exit 1
fi

# Validate status
if [[ "$NEW_STATUS" != "draft" && "$NEW_STATUS" != "defined" && "$NEW_STATUS" != "completed" ]]; then
    echo "Error: Invalid status '$NEW_STATUS'. Must be one of: draft, defined, completed" >&2
    exit 1
fi

# Check if task exists (either as top-level or subtask)
TASK_EXISTS=$(yq "
    [.[] | select(.name == \"$TASK_NAME\" and .status),
     .[] | .subtasks[]? | select(.name == \"$TASK_NAME\")] | length
" "$TASKS_FILE")

if [[ "$TASK_EXISTS" -eq 0 ]]; then
    echo "Error: Task '$TASK_NAME' not found in $TASKS_FILE" >&2
    exit 1
fi

# Update the task status
# This handles both top-level leaf tasks and subtasks
yq -i "
    (.[] | select(.name == \"$TASK_NAME\" and .status) | .status) = \"$NEW_STATUS\" |
    (.[] | .subtasks[]? | select(.name == \"$TASK_NAME\") | .status) = \"$NEW_STATUS\"
" "$TASKS_FILE"

echo "Updated task '$TASK_NAME' status to '$NEW_STATUS'"
