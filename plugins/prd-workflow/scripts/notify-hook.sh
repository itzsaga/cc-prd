#!/usr/bin/env bash
# Desktop notification hook for Claude Code events (optional)

set -euo pipefail

# Check for tmux
HAS_TMUX=false
if command -v tmux &>/dev/null && [[ -n "${TMUX:-}" ]]; then
    HAS_TMUX=true
fi

# Read event data from stdin
EVENT_DATA=$(cat)

# Extract event type
EVENT_TYPE=$(echo "$EVENT_DATA" | jq -r '.event // empty')

if [[ -z "$EVENT_TYPE" ]]; then
    exit 0
fi

send_notification() {
    local title="$1"
    local body="$2"
    local urgency="${3:-normal}"

    if command -v notify-send &>/dev/null; then
        notify-send -u "$urgency" "$title" "$body"
    elif command -v osascript &>/dev/null; then
        osascript -e "display notification \"$body\" with title \"$title\""
    fi
}

update_tmux_window() {
    local indicator="$1"

    if [[ "$HAS_TMUX" == "true" ]]; then
        local window_name
        window_name=$(tmux display-message -p '#W')

        # Add or remove indicator
        if [[ "$indicator" == "add" ]]; then
            if [[ ! "$window_name" =~ "🔴" ]]; then
                tmux rename-window "🔴 $window_name"
            fi
        elif [[ "$indicator" == "remove" ]]; then
            tmux rename-window "${window_name#🔴 }"
        fi
    fi
}

case "$EVENT_TYPE" in
    "Notification")
        # Critical notification - Claude needs attention
        MESSAGE=$(echo "$EVENT_DATA" | jq -r '.message // "Claude needs your attention"')
        send_notification "Claude Code" "$MESSAGE" "critical"
        update_tmux_window "add"
        ;;

    "PreToolUse")
        # Tool is about to be used - can be used for tracking
        # Uncomment to enable tool-specific notifications:
        # tool_name=$(echo "$EVENT_DATA" | jq -r '.tool_name // "unknown"')
        # send_notification "Claude Code" "Using tool: $tool_name"
        ;;

    "PostToolUse")
        # Tool completed
        ;;

    "SessionStart")
        # New session started
        update_tmux_window "remove"
        ;;

    "Stop"|"SubagentStop")
        # Session or subagent stopped
        update_tmux_window "remove"
        ;;

    "PreCompact")
        # Conversation is being compacted
        ;;

    *)
        # Unknown event type
        ;;
esac

exit 0
