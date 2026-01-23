# PRD File Specification
# Canonical reference for PRD document structure

PRD files are collaboration documents stored in `.claude/prds/[prd_name]/` directories.

## Required Structure

Each PRD requires a `PRD.md` file with these sections:

### Objective
User-defined goal with clarifying questions as needed.

### Motivation
Why this matters and what value it provides.

### Implementation Details
- **Architecture** - High-level design decisions
- **Constraints** - Technical and scope limitations
- **Relevant Guides** - Documentation references
- **Relevant Files** - Files to create/modify/delete

### Discussion
Agent questions and user answers in Q&A format.

## Supporting Files

### tasks.yaml
Sequential top-level tasks with optional parallel subtasks. Each leaf task needs an associated spec file.

Schema: `specs/tasks.schema.json`

### research.yaml (optional)
Research questions using "answer" or "deep-research" modes.

Schema: `specs/research.schema.json`

### log.md
Implementation log tracking completed work.

### specs/
Directory containing detailed task specification files.

## Key Rules

1. All relative paths are relative to the PRD directory, not the repository root
2. Store temporary files within the PRD directory
3. Top-level tasks execute sequentially; subtasks work in parallel
4. Each leaf task requires a detailed spec file for subagents
