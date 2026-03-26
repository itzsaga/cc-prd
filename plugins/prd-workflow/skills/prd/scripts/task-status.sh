#!/usr/bin/env bash
# Returns JSON with task counts by status for a PRD

set -euo pipefail

# Check dependencies
if ! command -v yq &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Error: Required dependencies (yq, jq) not found" >&2
    exit 1
fi

usage() {
    echo "Usage: scripts/task-status.sh <prd-name>"
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
    jq -n '{"draft": 0, "defined": 0, "completed": 0, "total": 0}'
    exit 0
fi

# Handle empty or null YAML content
task_count=$(yq 'length' "$TASKS_FILE" 2>/dev/null || echo "0")
if [[ "$task_count" -eq 0 ]]; then
    jq -n '{"draft": 0, "defined": 0, "completed": 0, "total": 0}'
    exit 0
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
