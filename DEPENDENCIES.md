# Dependencies

This document details all dependencies required by the prd-workflow plugin.

## Required Dependencies

These must be installed for core functionality.

### jq

**Purpose:** JSON parsing and manipulation

**Used by:** All scripts, hooks

**Version:** Any recent version (1.6+)

**Installation:**

| Platform | Command |
|----------|---------|
| macOS (Homebrew) | `brew install jq` |
| Ubuntu/Debian | `apt install jq` |
| Arch Linux | `pacman -S jq` |
| NixOS | `nix-env -iA nixpkgs.jq` |
| Windows (Chocolatey) | `choco install jq` |

**Verification:**
```bash
jq --version
# Expected: jq-1.6 or higher
```

### yq

**Purpose:** YAML parsing and manipulation

**Used by:** Task management scripts, validation hooks

**Note:** This plugin uses `yq` by Mike Farah (Go version), not the Python yq wrapper.

**Installation:**

| Platform | Command |
|----------|---------|
| macOS (Homebrew) | `brew install yq` |
| Ubuntu/Debian | `snap install yq` |
| Arch Linux | `pacman -S yq` |
| NixOS | `nix-env -iA nixpkgs.yq-go` |
| pip (any platform) | `pip install yq` (Python wrapper - may have slight differences) |

**Verification:**
```bash
yq --version
# Expected: yq (https://github.com/mikefarah/yq/) version v4.x
```

### check-jsonschema

**Purpose:** JSON Schema validation for YAML files

**Used by:** Validation hooks

**Installation:**

| Platform | Command |
|----------|---------|
| All platforms | `pip install check-jsonschema` |

**Verification:**
```bash
check-jsonschema --version
# Expected: check-jsonschema, version X.X.X
```

## Optional Dependencies

These enable additional features but are not required.

### glow

**Purpose:** Markdown rendering in terminal

**Used for:** Pretty-printing PRD documents and specs

**Installation:**

| Platform | Command |
|----------|---------|
| macOS (Homebrew) | `brew install glow` |
| Ubuntu/Debian | `snap install glow` |
| Arch Linux | `pacman -S glow` |
| NixOS | `nix-env -iA nixpkgs.glow` |

**Verification:**
```bash
glow --version
```

### notify-send

**Purpose:** Desktop notifications (Linux)

**Used by:** Notification hook (optional)

**Installation:**

| Platform | Command |
|----------|---------|
| Ubuntu/Debian | `apt install libnotify-bin` |
| Arch Linux | `pacman -S libnotify` |

**Note:** On macOS, the notification hook uses `osascript` instead, which is built-in.

**Verification:**
```bash
notify-send --version
```

### tmux

**Purpose:** Terminal multiplexer integration

**Used by:** Notification hook for window indicators

**Installation:**

| Platform | Command |
|----------|---------|
| macOS (Homebrew) | `brew install tmux` |
| Ubuntu/Debian | `apt install tmux` |
| Arch Linux | `pacman -S tmux` |
| NixOS | `nix-env -iA nixpkgs.tmux` |

## MCP Server Dependencies

### Exa MCP Server

**Purpose:** Web search and research capabilities

**Used by:** `prd-researcher` agent, research.yaml workflows

**Required for:** Research phase of PRD planning

**Setup:**

1. Sign up at [Exa AI](https://exa.ai) and get an API key

2. Configure the MCP server in your Claude settings (method varies by Claude Code version)

3. Set the API key as an environment variable:
   ```bash
   export EXA_API_KEY="your-api-key-here"
   ```

**Graceful Degradation:** If Exa is not configured, the plugin will:
- Report that research features are unavailable
- Suggest manual research alternatives
- Allow the workflow to continue without automated research

## Dependency Check Script

You can verify all dependencies are installed:

```bash
#!/usr/bin/env bash
# Check prd-workflow dependencies

echo "Checking required dependencies..."

check_command() {
    if command -v "$1" &>/dev/null; then
        echo "  [OK] $1"
        return 0
    else
        echo "  [MISSING] $1"
        return 1
    fi
}

MISSING=0

check_command jq || MISSING=$((MISSING + 1))
check_command yq || MISSING=$((MISSING + 1))
check_command check-jsonschema || MISSING=$((MISSING + 1))

echo ""
echo "Checking optional dependencies..."

check_command glow || true
check_command notify-send || check_command osascript || true
check_command tmux || true

echo ""
if [[ $MISSING -eq 0 ]]; then
    echo "All required dependencies are installed!"
else
    echo "Missing $MISSING required dependencies. Please install them."
    exit 1
fi
```

## Troubleshooting

### yq: command not found

Make sure you installed the Go version of yq, not just the Python wrapper:
```bash
# Check which yq you have
which yq
yq --version

# If it shows Python yq, install the Go version via another method
```

### check-jsonschema: command not found

Ensure pip installed it to a location in your PATH:
```bash
pip show check-jsonschema
# Check the Location field

# You may need to add ~/.local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"
```

### Hooks fail silently

Hooks are designed to fail gracefully when dependencies are missing. Check the Claude Code output for warning messages about missing dependencies.

### Research features don't work

Verify Exa MCP is configured:
1. Check if `EXA_API_KEY` is set
2. Verify the MCP server is configured in Claude settings
3. Test with a simple research query
