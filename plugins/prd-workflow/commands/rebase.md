# Rebase Command
# Rebases current branch onto target branch with automatic conflict resolution

Rebase the current branch onto a target branch, handling conflicts intelligently.

## Arguments

- `target` (optional): Target branch to rebase onto
  - Default: fetches and rebases onto the default branch from origin
  - Can be: "origin", "origin/branch-name", or just "branch-name"

## Process

1. **Determine Target Branch**
   - If no argument or "origin": Use `git remote show origin` to find default branch
   - If specific branch provided: Parse and validate the branch name

2. **Fetch Updates**
   ```bash
   git fetch origin
   ```

3. **Execute Rebase**
   ```bash
   git rebase <target-branch>
   ```

4. **Handle Conflicts**
   When conflicts arise:
   - Examine recent history: `git log -p -n 3 <target>` to understand changes
   - Prioritize preserving changes from both branches where possible
   - For each conflicted file:
     1. Analyze the conflict markers
     2. Understand intent from both sides
     3. Resolve preserving meaningful changes
     4. Stage the resolution: `git add <file>`
   - Continue the rebase: `git rebase --continue`
   - Repeat until rebase completes

## Output

Provide only a compact summary:
- Number of commits rebased
- Files with conflicts (if any)
- Brief description of each resolution made

Keep intermediate operations silent. Only report the final outcome.

## Examples

```bash
# Rebase onto default branch
/rebase

# Rebase onto specific branch
/rebase develop

# Rebase onto remote branch
/rebase origin/main
```

## Error Handling

- If rebase cannot be completed automatically, report the blocker
- Never use `--abort` without user confirmation
- Preserve local changes when possible
