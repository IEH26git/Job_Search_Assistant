---
name: create-change-log
description: Create admin/Agent-Change-Log.md from scratch by compiling full history into an ASCII timeline + detailed entries
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Agent
  - Bash(date:*)
  - Bash(git:*)
  - Bash(ls:*)
  - Bash(find:*)
  - Bash(stat:*)
  - Bash(pwd:*)
  - Bash(mkdir:*)

---

Create `admin/Agent-Change-Log.md` from scratch by compiling the full history of changes to this agent.

## Step 1: Capture working directory and agent name

Run `pwd` and save the result as `AGENT_DIR`. Extract the final path component (e.g., `my-agent` from `/path/to/my-agent`) and save it as `AGENT_NAME`. Use these variables everywhere a path or agent name is needed in the steps below.

## Step 2: Check for existing file

Run `ls admin/Agent-Change-Log.md` before doing anything else.

If the file already exists, stop and tell the user: "`admin/Agent-Change-Log.md` already exists. Use `/update-change-log` to append new entries."

## Step 3: Get today's date

Run `date` and format as `YYYY-MM-DD`.

## Step 4: Compile full history via subagent

Check whether a git repo exists by running `git -C [AGENT_DIR] rev-parse --git-dir 2>/dev/null`. Save the result as `HAS_GIT`.

Then spawn an Explore subagent with the appropriate prompt based on `HAS_GIT`:

---

**If HAS_GIT is non-empty (git repo exists):**

> "Compile a complete chronological history of changes to the agent at `[AGENT_DIR]`. I need every meaningful change — skills added or modified, wiki pages created, CLAUDE.md updates, infrastructure changes (git init, folder creation, scripts), and admin files created.
>
> Steps:
> 1. Run `git log --oneline --format='%ad %s' --date=short` to get all commits with dates.
> 2. For each commit, run `git show --stat <hash>` to get the file list.
> 3. Run `git log --diff-filter=A --name-only --format='' | sort` to get all files ever added.
> 4. Check `.claude/commands/` for all skill files and their git creation dates via `git log --diff-filter=A --format='%ad' --date=short -- .claude/commands/*.md`.
> 5. Check `wiki/`, `outputs/`, `admin/`, `scripts/`, `browser/` for any existing files.
>
> Return a flat chronological list of all changes, one per line, with date (YYYY-MM-DD), category, and a one-line description of what changed. Group same-date items together."

---

**If HAS_GIT is empty (no git repo):**

> "Compile a complete inventory of files currently present in the agent at `[AGENT_DIR]`. I need every meaningful file — skills, wiki pages, CLAUDE.md, scripts, admin files, folder structure.
>
> Steps:
> 1. Run `find [AGENT_DIR] -not -path '*/.git/*' -not -name '.DS_Store' -not -name '.*' -type f | sort` to get all files.
> 2. For each file, run `stat -f '%SB %N' <file>` (macOS) to get the filesystem creation date.
> 3. Group files by their creation date.
>
> Return a flat chronological list of all files found, grouped by creation date, with date (YYYY-MM-DD), category (inferred from path and filename), and a one-line description of each file's purpose."

---

Wait for the subagent's response before proceeding.

## Step 5: Categorize the changes

Using the subagent's findings, group every change into one or more of these categories:

| Category label | When to use |
|:---|:---|
| **Skills installed** | New `.claude/commands/*.md` files |
| **Skills updated** | Existing skill files with substantive changes |
| **Wiki pages created / updated** | New or modified files in `wiki/` |
| **CLAUDE.md updated** | Behavioral rule additions or changes |
| **Admin files updated** | Changes to `admin/` files |
| **Infrastructure** | Git init, folder creation, scripts, settings |
| **Bug fix** | Defect corrections in skills or scripts |
| **Documentation** | New or updated templates, workflow docs |
| **Git repository initialized** | Only for the very first commit |

For a project build day (the date when the majority of skills and structure were created at once), use:
- `★  PROJECT BUILD DAY` as the timeline entry
- Sub-items use `·` symbol indented 10 spaces

## Step 6: Draft the full file

Compose the complete `Agent-Change-Log.md` using this structure:

```
# [AGENT_NAME] Agent Change Log

---

## Timeline

\```
  <YYYY>
  ──────────────────────────────────────────────────────────────────
  Mon DD  ●  <one-line summary>
  ──────────────────────────────────────────────────────────────────
  Mon DD  ★  PROJECT BUILD DAY
          ·  <sub-item>
          ·  <sub-item>
  ──────────────────────────────────────────────────────────────────

  Legend:  ●  Skill or infrastructure change
           ★  Major milestone
           ·  Build-day sub-item
\```

---

## Full Change Log

### YYYY-MM-DD

**Type:** <category>
**Scope:** <brief scope note>

**<Category label>**
- <specific item with filename, key detail, or produced artifact>

---

*This file is updated by `/update-change-log`. Run it at the end of any session where skills, CLAUDE.md, or infrastructure files were changed.*
```

Timeline formatting rules:
- Use `Mon DD` short date format with a leading space for single-digit days (e.g., `Apr  7`, `Apr 19`)
- `●` — skill or infrastructure change
- `★` — major milestone (build day, major structural change)
- `·` — build-day sub-item, indented 10 spaces under the `★` line
- Separate date groups with `  ──────────────────────────────────────────────────────────────────`
- Multiple items on the same date: second and subsequent items indented 10 spaces

## Step 7: Present draft to the user

Show the full drafted file. Ask:

> "Does this look right? Reply with any corrections, or confirm to write."

Wait for confirmation before writing.

## Step 8: Write the file

Run `mkdir -p [AGENT_DIR]/admin` to ensure the directory exists, then write the confirmed content to `admin/Agent-Change-Log.md`.

## Step 9: Update folder index

Check whether `admin/_folder_index.md` exists.

- If it exists: read it and add an entry for `Agent-Change-Log.md`.
- If it does not exist: create `admin/_folder_index.md` with a minimal index header and an entry for `Agent-Change-Log.md`.

## Step 10: Confirm

Tell the user:
- File path: `admin/Agent-Change-Log.md`
- Date range covered
- Number of entries logged
