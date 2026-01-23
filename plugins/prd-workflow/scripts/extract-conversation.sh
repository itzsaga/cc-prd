#!/usr/bin/env bash
# Extracts human-readable conversation from Claude transcript JSONL files

set -euo pipefail

# Check dependencies
if ! command -v jq &>/dev/null; then
    echo "Error: Required dependency (jq) not found" >&2
    exit 1
fi

usage() {
    echo "Usage: extract-conversation.sh < transcript.jsonl"
    echo "       cat transcript.jsonl | extract-conversation.sh"
    echo ""
    echo "Extracts conversation messages from Claude transcript JSONL format."
    echo "Outputs role: message pairs for user and assistant messages."
    exit 1
}

# Check for help flag
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
fi

# Process JSONL input
jq -r '
    select(.role == "user" or .role == "assistant") |
    .role as $role |
    (
        if (.content | type) == "string" then
            .content
        elif (.content | type) == "array" then
            (.content[0].text // "")
        else
            ""
        end
    ) as $text |
    if $text != "" then
        "\($role): \($text)"
    else
        empty
    end
' | grep -v '^\[{'
