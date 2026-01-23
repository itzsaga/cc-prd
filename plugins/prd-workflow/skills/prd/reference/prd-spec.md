# PRD Specification
# Defines the structure and rules for Product Requirements Documents

## Overview

A PRD (Product Requirements Document) is a structured format for defining concrete objectives and enabling collaboration between users and Claude. PRDs are stored in `.claude/prds/[prd_name]/` directories within repository roots.

## Directory Structure

```
.claude/prds/[prd-name]/
├── PRD.md           # Main PRD document
├── tasks.yaml       # Task definitions (created during planning)
├── research.yaml    # Research questions (optional)
├── log.md           # Implementation log (created during work)
└── specs/           # Task specification files
    └── *.md
```

## PRD.md Structure

```markdown
# [PRD Name]

## Objective

<Clear statement of what this PRD accomplishes. User-provided with clarifying questions as needed.>

## Motivation

<Why this matters. What value does it provide? What problem does it solve?>

## Implementation Details

### Architecture

<High-level architectural decisions. Filled during planning phase.>

### Constraints

<Concise, but precise description of limitations and requirements.>

- Constraint 1
- Constraint 2

### Relevant Guides

<Documentation and guides that inform implementation.>

- `path/to/guide.md`

### Relevant Files

<Files that will be created, modified, or deleted.>

- `path/to/file.ts` - (Edit) Description of changes
- `path/to/new-file.ts` - (Create) Description of purpose

## Discussion

### [Question Topic]

_[Full question from Claude]_

[User's answer]
```

## tasks.yaml Structure

Top-level tasks execute **sequentially**. Subtasks execute **in parallel**.

```yaml
# Leaf task (no subtasks)
- name: "Task name"
  description: "Detailed description"
  status: draft|defined|completed
  spec: "specs/task-name.md"

# Parent task with subtasks
- name: "Parent task name"
  description: "What this group accomplishes"
  subtasks:
    - name: "Subtask 1"
      description: "Description"
      status: draft|defined|completed
      spec: "specs/subtask-1.md"
    - name: "Subtask 2"
      description: "Description"
      status: draft|defined|completed
      spec: "specs/subtask-2.md"
```

**Task statuses**:
- `draft` - Task defined but spec not complete
- `defined` - Spec complete, ready for implementation
- `completed` - Implementation finished

## research.yaml Structure

```yaml
- text: "Research question text"
  mode: answer|deep-research
  answer: "Answer from research (populated after research)"
  citations:
    - url: "https://example.com"
      title: "Source Title"
```

**Research modes**:
- `answer` - Quick search, returns direct answer
- `deep-research` - Comprehensive analysis, takes longer

## Key Rules

1. **Relative Paths**: All paths in PRD files are relative to the PRD directory, not the repository root

2. **Temporary Files**: Store any temporary files within the PRD directory

3. **File Actions**: Use these labels in Relevant Files:
   - `(Edit)` - Modify existing file
   - `(Create)` - Create new file
   - `(Delete)` - Remove file
   - `(Review)` - Reference only, no changes

4. **Constraints**: Keep them "concise, but precise"

5. **Self-Containment**: After planning, the PRD should contain all context needed for implementation

## Schema Validation

Task and research files are validated against JSON schemas:
- `specs/tasks.schema.json`
- `specs/research.schema.json`
