#!/usr/bin/env bash
# Returns JSON with task counts by status for a PRD

set -euo pipefail

# Check dependencies
if ! command -v yq &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Error: Required dependencies (yq, jq) not found" >&2
    exit 1
fi

usage() {
    echo "Usage: claude-PRD-task-status <prd-name>"
    echo ""
    echo "Returns JSON with task counts by status and total."
    exit 1
}

if [[ $# -lt 1 ]]; then
    usage
fi

PRD_NAME="$1"
TASKS_FILE=".claude/prds/${PRD_NAME}/tasks.yaml"

if [[ ! -f "$TASKS_FILE" ]]; then
    echo "Error: Tasks file not found: $TASKS_FILE" >&2
    exit 1
fi

# Count tasks by status (both top-level leaf tasks and subtasks)
draft=$(yq '
    [
        .[] | select(.status == "draft"),
        .[] | .subtasks[]? | select(.status == "draft")
    ] | length
' "$TASKS_FILE")

defined=$(yq '
    [
        .[] | select(.status == "defined"),
        .[] | .subtasks[]? | select(.status == "defined")
    ] | length
' "$TASKS_FILE")

completed=$(yq '
    [
        .[] | select(.status == "completed"),
        .[] | .subtasks[]? | select(.status == "completed")
    ] | length
' "$TASKS_FILE")

total=$((draft + defined + completed))

jq -n \
    --argjson draft "$draft" \
    --argjson defined "$defined" \
    --argjson completed "$completed" \
    --argjson total "$total" \
    '{
        "draft": $draft,
        "defined": $defined,
        "completed": $completed,
        "total": $total
    }'
