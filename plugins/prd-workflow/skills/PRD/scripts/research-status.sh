#!/usr/bin/env bash
# Returns JSON describing research question status for a PRD

set -euo pipefail

# Check dependencies
if ! command -v yq &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Error: Required dependencies (yq, jq) not found" >&2
    exit 1
fi

usage() {
    echo "Usage: claude-PRD-research-status <prd-name>"
    echo ""
    echo "Returns JSON with research question counts: draft, complete, and total."
    exit 1
}

if [[ $# -lt 1 ]]; then
    usage
fi

PRD_NAME="$1"
RESEARCH_FILE=".claude/prds/${PRD_NAME}/research.yaml"

if [[ ! -f "$RESEARCH_FILE" ]]; then
    # No research file - return zeros
    jq -n '{
        "draft": 0,
        "complete": 0,
        "total": 0
    }'
    exit 0
fi

# Count questions by status
# Draft = no answer or empty answer
draft=$(yq '
    [.[] | select(.answer == null or .answer == "")] | length
' "$RESEARCH_FILE")

# Complete = has an answer
complete=$(yq '
    [.[] | select(.answer != null and .answer != "")] | length
' "$RESEARCH_FILE")

total=$((draft + complete))

jq -n \
    --argjson draft "$draft" \
    --argjson complete "$complete" \
    --argjson total "$total" \
    '{
        "draft": $draft,
        "complete": $complete,
        "total": $total
    }'
