#!/usr/bin/env bash
# Validates the structure of a tasks.yaml file after editing

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SCHEMA_PATH="${PLUGIN_ROOT}/specs/tasks.schema.json"

# Check for required dependencies
check_dependencies() {
    local missing=()

    if ! command -v jq &>/dev/null; then
        missing+=("jq")
    fi

    if ! command -v yq &>/dev/null; then
        missing+=("yq")
    fi

    if ! command -v check-jsonschema &>/dev/null; then
        missing+=("check-jsonschema")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Missing required dependencies: ${missing[*]}" >&2
        echo "Please install them before using this hook." >&2
        exit 0  # Exit gracefully to not block Claude
    fi
}

check_dependencies

# Read JSON input from stdin
INPUT=$(cat)

# Extract file path from tool_input
FILE_PATH=$(jq -r '.tool_input.file_path // empty' <<< "$INPUT")

if [[ -z "$FILE_PATH" ]]; then
    # Not a file operation, skip
    exit 0
fi

# Only validate tasks.yaml files in .claude directories
if [[ ! "$FILE_PATH" =~ \.claude/prds/.*/tasks\.yaml$ ]]; then
    exit 0
fi

if [[ ! -f "$FILE_PATH" ]]; then
    echo "File not found: $FILE_PATH" >&2
    exit 0
fi

echo "Validating: $FILE_PATH" >&2

ERRORS=""

# Validate against schema
if ! SCHEMA_OUTPUT=$(check-jsonschema --schemafile "$SCHEMA_PATH" "$FILE_PATH" 2>&1); then
    ERRORS="${ERRORS}Schema validation failed:\n${SCHEMA_OUTPUT}\n\n"
fi

# Check that tasks with "defined" status have corresponding spec files
PRD_DIR=$(dirname "$FILE_PATH")

# Get all leaf tasks with defined status
DEFINED_TASKS=$(yq -o=json '
    [
        .[] | select(.status == "defined") | {name: .name, spec: .spec},
        .[] | .subtasks[]? | select(.status == "defined") | {name: .name, spec: .spec}
    ]
' "$FILE_PATH" 2>/dev/null || echo "[]")

if [[ "$DEFINED_TASKS" != "[]" ]]; then
    while IFS= read -r task; do
        TASK_NAME=$(jq -r '.name' <<< "$task")
        SPEC_PATH=$(jq -r '.spec // empty' <<< "$task")

        if [[ -n "$SPEC_PATH" ]]; then
            FULL_SPEC_PATH="${PRD_DIR}/${SPEC_PATH}"
            if [[ ! -f "$FULL_SPEC_PATH" ]]; then
                ERRORS="${ERRORS}Task '${TASK_NAME}' has status 'defined' but spec file not found: ${FULL_SPEC_PATH}\n"
            fi
        fi
    done < <(jq -c '.[]' <<< "$DEFINED_TASKS")
fi

# If there are errors, output blocking response
if [[ -n "$ERRORS" ]]; then
    jq -n \
        --arg reason "$(echo -e "$ERRORS")Please fix the tasks.yaml structure before proceeding." \
        '{
            "decision": "block",
            "reason": $reason
        }'
    exit 0
fi

echo "OK" >&2
exit 0
