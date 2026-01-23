#!/usr/bin/env bash
# Retrieves detailed information about a specific task in a PRD

set -euo pipefail

# Check dependencies
if ! command -v yq &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Error: Required dependencies (yq, jq) not found" >&2
    exit 1
fi

usage() {
    echo "Usage: claude-PRD-get-task <prd-name> <task-name>"
    echo ""
    echo "Returns full task details including status, spec path, and file locations."
    exit 1
}

if [[ $# -lt 2 ]]; then
    usage
fi

PRD_NAME="$1"
TASK_NAME="$2"
PRD_DIR=".claude/prds/${PRD_NAME}"
TASKS_FILE="${PRD_DIR}/tasks.yaml"
PRD_FILE="${PRD_DIR}/PRD.md"
LOG_FILE="${PRD_DIR}/log.md"

if [[ ! -d "$PRD_DIR" ]]; then
    jq -n --arg prd "$PRD_NAME" '{
        "found": false,
        "error": "PRD directory not found",
        "prd_name": $prd
    }'
    exit 0
fi

if [[ ! -f "$TASKS_FILE" ]]; then
    jq -n --arg prd "$PRD_NAME" '{
        "found": false,
        "error": "Tasks file not found",
        "prd_name": $prd
    }'
    exit 0
fi

# Try to find task as a top-level leaf task
# shellcheck disable=SC2016 # $name is a yq variable, not bash
TASK_DATA=$(yq -o=json \
    --arg name "$TASK_NAME" \
    '.[] | select(.name == $name and .status) | {name, description, status, spec}' \
    "$TASKS_FILE" 2>/dev/null || echo "")

PARENT=""

# If not found, search in subtasks
if [[ -z "$TASK_DATA" || "$TASK_DATA" == "null" ]]; then
    # shellcheck disable=SC2016 # $name is a yq variable, not bash
    TASK_DATA=$(yq -o=json \
        --arg name "$TASK_NAME" \
        '.[] | select(.subtasks) | .subtasks[] | select(.name == $name) | {name, description, status, spec}' \
        "$TASKS_FILE" 2>/dev/null || echo "")

    # Get parent name
    if [[ -n "$TASK_DATA" && "$TASK_DATA" != "null" ]]; then
        # shellcheck disable=SC2016 # $name is a yq variable, not bash
        PARENT=$(yq \
            --arg name "$TASK_NAME" \
            '.[] | select(.subtasks) | select(.subtasks[].name == $name) | .name' \
            "$TASKS_FILE" 2>/dev/null || echo "")
    fi
fi

if [[ -z "$TASK_DATA" || "$TASK_DATA" == "null" ]]; then
    jq -n \
        --arg prd "$PRD_NAME" \
        --arg task "$TASK_NAME" \
        '{
            "found": false,
            "error": "Task not found",
            "prd_name": $prd,
            "task_name": $task
        }'
    exit 0
fi

# Extract spec path and build full paths
SPEC_REL=$(jq -r '.spec // empty' <<< "$TASK_DATA")
SPEC_PATH=""
SPEC_EXISTS="false"

if [[ -n "$SPEC_REL" ]]; then
    SPEC_PATH="${PRD_DIR}/${SPEC_REL}"
    if [[ -f "$SPEC_PATH" ]]; then
        SPEC_EXISTS="true"
    fi
fi

LOG_EXISTS="false"
if [[ -f "$LOG_FILE" ]]; then
    LOG_EXISTS="true"
fi

# Build final output
jq -n \
    --argjson task "$TASK_DATA" \
    --arg parent "$PARENT" \
    --arg prd_name "$PRD_NAME" \
    --arg prd_path "$PRD_FILE" \
    --arg spec_path "$SPEC_PATH" \
    --argjson spec_exists "$SPEC_EXISTS" \
    --arg log_path "$LOG_FILE" \
    --argjson log_exists "$LOG_EXISTS" \
    '{
        "name": $task.name,
        "description": $task.description,
        "status": $task.status,
        "spec": $task.spec,
        "spec_path": $spec_path,
        "spec_exists": $spec_exists,
        "parent": (if $parent == "" then null else $parent end),
        "prd_name": $prd_name,
        "prd_path": $prd_path,
        "log_path": $log_path,
        "log_exists": $log_exists,
        "found": true
    }'
