#!/usr/bin/env bash
# Returns JSON array of unanswered research questions for a PRD

set -euo pipefail

# Check dependencies
if ! command -v yq &>/dev/null; then
    echo "Error: Required dependency (yq) not found" >&2
    exit 1
fi

usage() {
    echo "Usage: claude-PRD-get-unanswered-research <prd-name>"
    echo ""
    echo "Returns JSON array of unanswered research questions."
    echo "Each question includes 'text' and 'mode' fields."
    exit 1
}

if [[ $# -lt 1 ]]; then
    usage
fi

PRD_NAME="$1"
RESEARCH_FILE=".claude/prds/${PRD_NAME}/research.yaml"

if [[ ! -f "$RESEARCH_FILE" ]]; then
    echo "Error: Research file not found: $RESEARCH_FILE" >&2
    exit 1
fi

# Get questions without answers
yq -o=json '
    [.[] | select(.answer == null or .answer == "") | {
        "text": .text,
        "mode": .mode
    }]
' "$RESEARCH_FILE"
