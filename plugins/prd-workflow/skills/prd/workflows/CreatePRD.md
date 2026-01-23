# CreatePRD Workflow
# Creates a new Product Requirements Document

## Purpose

Gather requirements from the user and create a structured PRD document.

## Steps

### Step 1: Gather Objective

Ask the user:
- What do you want to accomplish?
- Who is this for?
- What does success look like?

Document their responses clearly.

### Step 2: Gather Motivation

Ask the user:
- Why does this matter now?
- What value does this provide?
- What problem does this solve?

### Step 3: Identify Constraints

Discuss and document:
- Technical constraints (languages, frameworks, compatibility)
- Performance requirements
- Scope limitations
- Timeline considerations (if any)

### Step 4: Document Discussion

Record all clarifying questions and answers as structured Q&A pairs:

```markdown
### [Question Topic]

_[Full question text]_

[User's answer]
```

### Step 5: Create PRD Directory

Create the PRD at `.claude/prds/[prd-name]/PRD.md`

**Naming rules**:
- Use kebab-case for directory names
- Keep names concise but descriptive
- Example: `user-authentication`, `api-rate-limiting`

### Step 6: Fill Key Sections

Complete these sections based on gathered information:

```markdown
# [PRD Name]

## Objective

[Clear statement of what this PRD accomplishes]

## Motivation

[Why this matters and what value it provides]

## Implementation Details

### Architecture

To be determined during planning.

### Constraints

- [Constraint 1]
- [Constraint 2]

### Relevant Guides

To be determined during planning.

### Relevant Files

To be determined during planning.

## Discussion

[All Q&A pairs from Step 4]
```

### Step 7: Use Placeholders

Leave these sections as placeholders - they will be filled during PlanPRD:

- Architecture
- Relevant Guides
- Relevant Files

Use the text: "To be determined during planning."

### Step 8: Skip tasks.yaml

**Do not create** `tasks.yaml` during this phase. Task definition happens in the PlanPRD workflow.

### Step 9: Validate and Confirm

Review the PRD with the user:
1. Read the created PRD back to them
2. Ask if the objective is clear
3. Ask if any constraints are missing
4. Confirm they're ready to proceed to planning

## Output

After completion:
1. Display the path to the created PRD
2. Summarize what was captured
3. Suggest next step: "Run `/prd plan [name]` to begin planning"

## Key Principles

- Capture requirements, not implementation details
- Leave room for the planning phase
- Document everything discussed
- Be thorough but don't over-specify
