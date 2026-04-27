---
name: git-commit-push
description: Stage all changes, generate a summary commit message, commit, and push to the remote
argument-hint: "[optional commit message override]"
allowed-tools:
  - Bash(date:*)
  - Bash(git:*)
---

Stage all changes in the current repo, generate a descriptive commit message from the diff, commit, and push.

## Steps

### Step 1: Get today's date

Run `date` to get today's date in YYYY-MM-DD format.

### Step 2: Stage all changes

```bash
git add .
```

### Step 3: Check what's staged

```bash
git diff --staged --name-status
```

If nothing is staged ("nothing to commit"), skip the commit and push entirely and report: "Nothing to commit."

### Step 4: Generate the commit message

Parse the staged diff output:
- Lines starting with `A` = added files
- Lines starting with `M` = modified files
- Lines starting with `D` = deleted files

If the user provided an argument to this skill, use it as the commit message verbatim.

Otherwise, format the commit message as:
```
Wrap-up YYYY-MM-DD — N files changed: +added.md, ~modified.md, -deleted.md
```

Rules for the summary suffix:
- List added files with `+`, modified with `~`, deleted with `-`
- If there are more than 4 changed files total, summarize by count instead: `+2 added, ~3 modified`

### Step 5: Commit and push

```bash
git commit -m "<generated or provided message>"
git push
```

If `push` fails, report it so the user is aware.

### Step 6: Report

Tell the user:
- How many files were staged (added / modified / deleted)
- The commit message used
- Whether the push succeeded or failed
