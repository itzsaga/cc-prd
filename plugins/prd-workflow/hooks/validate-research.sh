#!/usr/bin/env bash
# Validates the structure of a research.yaml file after editing

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SCHEMA_PATH="${PLUGIN_ROOT}/specs/research.schema.json"

# Check for required dependencies
check_dependencies() {
    local missing=()

    if ! command -v jq &>/dev/null; then
        missing+=("jq")
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

# Only validate research.yaml files
if [[ ! "$FILE_PATH" =~ research\.yaml$ ]]; then
    exit 0
fi

if [[ ! -f "$FILE_PATH" ]]; then
    echo "File not found: $FILE_PATH" >&2
    exit 0
fi

echo "Validating: $FILE_PATH" >&2

if ! check-jsonschema --schemafile "$SCHEMA_PATH" "$FILE_PATH" 2>&1; then
    # Output structured response for Claude
    jq -n \
        --arg reason "Schema validation failed for $FILE_PATH. Please fix the YAML structure." \
        '{
            "decision": "block",
            "reason": $reason
        }'
    exit 0
fi

echo "OK" >&2
exit 0
