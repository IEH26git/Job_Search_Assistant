---
description: Generate a session log summarizing what was planned or executed in this conversation
argument-hint: "<topic-slug> (e.g., resume-agent, task-board-refactor)"
allowed-tools:
  - Read
  - Write
  - Bash(date:*)
---

Generate a session log for the current conversation and save it to the TaskMgmt folder.

## Output Location

`<WORKSPACE_PATH>/TaskMgmt/YYYY-MM-DD.md`

If a slug argument is provided, use `YYYY-MM-DD-<slug>.md` instead (e.g., `resume-agent` → `2026-02-18-resume-agent.md`).

If no argument is provided, use just the date.

---

## Steps

### Step 1: Get today's date

Run `date` to get today's date in YYYY-MM-DD format.

### Step 2: Count the prompts

Count the total number of user prompts in this conversation (every message Ian sent, including this one).

### Step 3: Write the log

Create the log file using this structure:

```
# YYYY-MM-DD — Claude Code Session Log

## Session Overview - N prompts

One sentence describing what this session accomplished overall.

---

## Prompt 1

> Verbatim text of Ian's first message

Claude's response or actions, described in prose. Include what was done, what was created or changed (file paths where relevant), and any key decisions made or options presented. If Claude asked a clarifying question, note that too.

---

## Prompt 2

> Verbatim text of Ian's second message

Claude's response or actions described in prose.

---

[...continue for every prompt in the session...]

---

## Files Created or Modified This Session

**New files:**
- `path/to/new-file.md`

**Modified files:**
- `path/to/modified-file.md`

**Renamed files:**
- `old/path.md` → `new/path.md`
```

### Step 4: Confirm

Tell the user the file path where the log was saved.

---

## Notes

- Include every user prompt verbatim in a blockquote (`> text`)
- Describe Claude's responses in prose — what was done, what changed, what was decided
- Omit the "Files" section at the end if no files were created, modified, or renamed
- Omit individual subsections (New / Modified / Renamed) if empty
