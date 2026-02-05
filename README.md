# Claude Code Plugin Marketplace

A portable plugin marketplace for Claude Code, featuring a comprehensive PRD (Product Requirements Document) workflow system.

## Overview

This marketplace provides plugins that extend Claude Code with structured workflows, commands, and automation. The flagship plugin is `prd-workflow`, which offers a complete system for creating, planning, and implementing product requirements.

## Installation

### Prerequisites

Ensure you have the required dependencies installed. See [DEPENDENCIES.md](DEPENDENCIES.md) for detailed installation instructions.

**Required:**
- `jq` - JSON parsing
- `yq` - YAML parsing
- `check-jsonschema` - Schema validation

**Optional:**
- `glow` - Markdown rendering
- Exa MCP server - For research capabilities

### Quick Install Dependencies

**macOS (Homebrew):**
```bash
brew install jq yq
pip install check-jsonschema
```

**Ubuntu/Debian:**
```bash
apt install jq
snap install yq  # or: pip install yq
pip install check-jsonschema
```

**Arch Linux:**
```bash
pacman -S jq yq
pip install check-jsonschema
```

### Installing the Plugin

Once Claude Code supports plugin marketplaces, you can install via:

```bash
/plugin marketplace add /path/to/jackbot-ai
/plugin install prd-workflow
```

Until then, you can manually symlink or copy the plugin contents to your Claude configuration.

## Available Plugins

### prd-workflow

A complete PRD workflow system with three main phases:

1. **Create** - Gather requirements and create structured PRD documents
2. **Plan** - Analyze, research, and define detailed task specifications
3. **Work** - Implement defined tasks with tracking and logging

#### Features

- **Agents**: Specialized subagents for research and implementation
- **Commands**: Git rebase with intelligent conflict resolution
- **Hooks**: Automatic validation of task and research YAML files
- **Skills**: Full PRD workflow with routing logic
- **Scripts**: CLI tools for task and research management

#### Usage

```bash
# Create a new PRD
/prd create my-feature

# Plan an existing PRD (research and task definition)
/prd plan my-feature

# Work on a planned PRD (implementation)
/prd work my-feature

# Check PRD status
claude-PRD-list-prds
claude-PRD-task-status my-feature
```

## Directory Structure

```
cc-prd/
├── .claude-plugin/
│   └── marketplace.json       # Marketplace catalog
├── plugins/
│   └── prd-workflow/          # PRD workflow plugin
│       ├── .claude-plugin/
│       │   └── plugin.json    # Plugin configuration
│       ├── agents/            # Subagent definitions
│       ├── commands/          # Custom commands
│       ├── hooks/             # Validation hooks
│       ├── skills/            # Skill definitions
│       ├── specs/             # JSON schemas
│       └── scripts/           # Utility scripts
├── README.md
└── DEPENDENCIES.md
```

## Configuration

### Exa MCP Server (Optional)

The `prd-researcher` agent uses Exa MCP tools for web research. To enable:

1. Get an API key from [Exa AI](https://exa.ai)
2. Configure the Exa MCP server in your Claude settings
3. Set `EXA_API_KEY` environment variable

Without Exa, the research features will gracefully degrade with appropriate error messages.

### Hooks

Hooks automatically validate `tasks.yaml` and `research.yaml` files when edited. They require `jq`, `yq`, and `check-jsonschema` to be installed.

If dependencies are missing, hooks will log a warning but won't block operations.

## PRD File Structure

PRDs are stored in `.claude/prds/<prd-name>/`:

```
.claude/prds/my-feature/
├── PRD.md              # Main requirements document
├── tasks.yaml          # Task definitions
├── research.yaml       # Research questions (optional)
├── log.md              # Implementation log
└── specs/              # Task specification files
    └── task-name.md
```

## CLI Tools

| Command | Description |
|---------|-------------|
| `claude-PRD-list-prds` | List all PRDs with status |
| `claude-PRD-task-status <prd>` | Get task counts by status |
| `claude-PRD-get-task <prd> <task>` | Get full task details |
| `claude-PRD-list-draft-tasks <prd>` | List tasks needing specs |
| `claude-PRD-list-defined-tasks <prd>` | List tasks ready to implement |
| `claude-PRD-update-task-status <prd> <task> <status>` | Update task status |
| `claude-PRD-research-status <prd>` | Get research completion status |
| `claude-PRD-get-unanswered-research <prd>` | Get pending research questions |

## Credits

Adapted from [fullykubed/nixos-config](https://github.com/fullykubed/nixos-config/tree/main/modules/common/claude) - converted from NixOS-specific configuration to a portable plugin format.

## License

MIT
