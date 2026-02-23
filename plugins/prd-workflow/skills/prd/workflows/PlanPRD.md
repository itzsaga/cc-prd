# PlanPRD Workflow
# Analyzes, researches, and creates task definitions for an existing PRD

## Prerequisites

Before starting:
1. Verify the PRD exists using `scripts/list-prds.sh`
2. Confirm the PRD has required sections (Objective, Motivation, Implementation Details, Discussion)
3. Check task status with `scripts/task-status.sh <prd-name>`

## Steps

### Step 1: Deep Analysis

Read the PRD thoroughly and analyze:
- Completeness: Are all sections filled appropriately?
- Consistency: Do constraints align with objectives?
- Specificity: Is the objective clear enough to implement?

Document any gaps or ambiguities found.

### Step 2: Codebase Exploration

Explore the existing codebase to understand:
- Relevant existing code patterns
- Files that will need modification
- Dependencies and integrations
- Testing patterns in use

Update the PRD's "Relevant Files" section with findings.

### Step 3: User Clarification

For any ambiguities or architectural decisions:
- Present options with trade-offs
- Ask the user for their preference
- Document answers in the Discussion section

### Checkpoint 1 (Step 4)

**Decision point**: Do the clarifications require re-analysis?
- If significant changes → Return to Step 1
- If minor clarifications → Continue to Step 5

### Step 5: Generate Research Questions

Identify what you don't know:
- Unfamiliar libraries or APIs
- Best practices for specific patterns
- Integration approaches

Create `research.yaml` with questions (max 25):

```yaml
- text: "What is the recommended way to handle X in Y framework?"
  mode: answer  # or deep-research for complex topics
```

### Step 6: Execute Research

For each unanswered question (use `scripts/get-unanswered-research.sh`):
1. Launch `prd-researcher` subagent with the question
2. Capture the response and citations
3. Update `research.yaml` with the answer

Use `scripts/research-status.sh` to track progress.

### Checkpoint 2 (Step 7)

**Decision point**: Do research findings invalidate the analysis?
- If major discoveries → Return to Step 1 with new context
- If findings align → Continue to Step 8

### Step 8: Refine PRD

Update the PRD incorporating:
- Research findings (integrate into Architecture section)
- Resolved discussion points
- Refined constraints
- Updated file references

### Step 9: Generate Tasks

Create `tasks.yaml` following these principles:
- Top-level tasks execute **sequentially**
- Subtasks execute **in parallel**
- Each leaf task needs a spec file

```yaml
- name: "Set up authentication infrastructure"
  description: "Create the base auth module and configuration"
  subtasks:
    - name: "Create auth configuration"
      description: "Set up environment variables and config files"
      status: draft
      spec: "specs/auth-config.md"
    - name: "Create auth middleware"
      description: "Implement authentication middleware"
      status: draft
      spec: "specs/auth-middleware.md"

- name: "Implement login endpoint"
  description: "Create the login API endpoint"
  status: draft
  spec: "specs/login-endpoint.md"
```

### Step 10: Create Spec Files

For each draft task, create a detailed spec file following `reference/task-spec.md`:

1. Read the task-spec template
2. Fill in all sections for the specific task
3. Include concrete file paths and line numbers
4. Define clear acceptance criteria
5. Update task status to "defined"

Use `scripts/update-task-status.sh <prd> <task> defined` after each spec is complete.

### Step 11: Validation

Verify before completing:
- [ ] All research questions answered (`research-status` shows draft: 0)
- [ ] All discussion questions resolved
- [ ] Objective is clear and achievable
- [ ] All constraints documented
- [ ] All tasks have status "defined" (`task-status` shows draft: 0)
- [ ] All spec files exist and are complete

## Output

After completion:
1. Display final task status counts
2. Summarize what was planned
3. List any concerns or risks identified
4. Suggest next step: "Run `/prd work [name]` to begin implementation"

## Key Principles

- Document all findings explicitly in the PRD
- Keep skip conditions strict - all conditions must be met
- Ensure the PRD is self-contained after planning
- Research findings must be integrated, not just referenced
- Create specs that a subagent can implement independently
