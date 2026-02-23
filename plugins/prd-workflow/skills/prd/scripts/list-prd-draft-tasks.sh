#!/usr/bin/env bash
# Lists all leaf tasks with draft status for a PRD

set -euo pipefail

# Check dependencies
if ! command -v yq &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Error: Required dependencies (yq, jq) not found" >&2
    exit 1
fi

usage() {
    echo "Usage: scripts/list-prd-draft-tasks.sh <prd-name>"
    echo ""
    echo "Lists all leaf tasks (tasks without subtasks) that are in draft status."
    exit 1
}

if [[ $# -lt 1 ]]; then
    usage
fi

PRD_NAME="$1"
PRD_DIR=".claude/prds/${PRD_NAME}"
TASKS_FILE="${PRD_DIR}/tasks.yaml"

if [[ ! -d "$PRD_DIR" ]]; then
    echo "Error: PRD directory not found: $PRD_DIR" >&2
    exit 1
fi

if [[ ! -f "$TASKS_FILE" ]]; then
    echo "[]"
    exit 0
fi

# Get draft tasks from both top-level and subtasks
# shellcheck disable=SC2016 # $parent is a yq variable, not bash
yq -o=json '
    [
        # Top-level leaf tasks with draft status
        .[] | select(.status == "draft") | {
            "name": .name,
            "description": .description,
            "spec": .spec,
            "parent": null
        },
        # Subtasks with draft status
        .[] | select(.subtasks) | . as $parent | .subtasks[] | select(.status == "draft") | {
            "name": .name,
            "description": .description,
            "spec": .spec,
            "parent": $parent.name
        }
    ]
' "$TASKS_FILE"
