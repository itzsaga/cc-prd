#!/usr/bin/env bash
# Lists all PRDs with their status and task completion counts

set -euo pipefail

# Check dependencies
if ! command -v yq &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Error: Required dependencies (yq, jq) not found" >&2
    exit 1
fi

PRD_DIR=".claude/prds"

if [[ ! -d "$PRD_DIR" ]]; then
    echo "[]"
    exit 0
fi

# Build JSON array of PRD statuses
result="[]"

for prd_path in "$PRD_DIR"/*/; do
    if [[ ! -d "$prd_path" ]]; then
        continue
    fi

    prd_name=$(basename "$prd_path")
    tasks_file="${prd_path}tasks.yaml"

    if [[ ! -f "$tasks_file" ]]; then
        # No tasks file
        result=$(jq --arg name "$prd_name" \
            '. += [{"name": $name, "status": "no-tasks", "completed": 0, "total": 0}]' \
            <<< "$result")
        continue
    fi

    # Count tasks by status
    completed=$(yq '
        [
            .[] | select(.status == "completed"),
            .[] | .subtasks[]? | select(.status == "completed")
        ] | length
    ' "$tasks_file" 2>/dev/null || echo "0")

    total=$(yq '
        [
            .[] | select(.status),
            .[] | .subtasks[]?
        ] | length
    ' "$tasks_file" 2>/dev/null || echo "0")

    # Determine status
    if [[ "$total" -eq 0 ]]; then
        status="no-tasks"
    elif [[ "$completed" -eq 0 ]]; then
        status="draft"
    elif [[ "$completed" -eq "$total" ]]; then
        status="complete"
    else
        status="in-progress"
    fi

    result=$(jq --arg name "$prd_name" \
        --arg status "$status" \
        --argjson completed "$completed" \
        --argjson total "$total" \
        '. += [{"name": $name, "status": $status, "completed": $completed, "total": $total}]' \
        <<< "$result")
done

echo "$result"
