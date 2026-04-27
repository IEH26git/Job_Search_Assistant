---
name: update-change-log
description: Summarize recent changes and append them to Agent-Change-Log.md in the established format
argument-hint: ""
allowed-tools:
  - Read
  - Edit
  - Glob
  - Bash(date:*)
  - Bash(git:*)
  - Bash(ls:*)

---

Summarize what has changed since the last change log entry and append it to `Agent-Change-Log.md`.

## Steps

### Step 1: Get today's date

Run `date` and format as `YYYY-MM-DD`. Also format the short form used in the timeline (`Mon DD` with leading space for single-digit days, e.g., `Apr  7` or `Apr 19`).

### Step 2: Read the change log

Read `Agent-Change-Log.md` in full. Identify:
- The date of the most recent entry (appears as `### YYYY-MM-DD` at the bottom of the Detailed Change Log section)
- The exact last line before `*This file is updated by…*` so you can anchor your append point

### Step 3: Gather what changed

Run `git log --oneline --since="<last-log-date>"` to find commits since the last entry.

Then check for new or modified files in these areas:
- `.claude/commands/` — new or updated skills
- `Agent-Change-Log.md` — the change log itself
- `CLAUDE.md` — any behavioral rule changes
- `Templates/` — new or updated templates
- `Resume/` — resume automation files
- `Content/` — notable content additions
- `Daily Notes/` — session work worth noting
- `Weekly Summaries/` — generated summaries

Use `git show --stat <commit>` or `git diff --name-status <last-log-date>..HEAD` to get a complete file-change list.

### Step 4: Categorize the changes

Group the changes into one or more of these categories (use only the ones that apply):

| Category label | When to use |
|:---|:---|
| **Skills installed** | New `.claude/commands/*.md` files |
| **Skills updated** | Existing skill files with substantive changes |
| **CLAUDE.md updated** | Behavioral rule additions or changes |
| **Change log updated** | Changes to `Agent-Change-Log.md` |
| **Infrastructure** | Git setup, permissions settings, folder structure |
| **Bug fix** | Defect corrections in skills or scripts |
| **Documentation** | New or updated templates, workflow docs |
| **Git repository initialized** | Only for the very first commit |

If today matches an entry already in the log, append sub-items to that date's section rather than creating a new one.

### Step 5: Draft the timeline line(s)

Use the short date format. If this date already appears in the timeline, skip adding a new timeline line (only add the Detailed Change Log section below).

Format:
```
  ──────────────────────────────────────────────────────────────────
  Mon DD  ●  <one-line summary>
```

Use the correct symbol:
- `●` — skill or infrastructure change
- `★` — major milestone (build day, major structural change)
- `·` — build-day sub-item (indent under a `★` line with 10 spaces)

If multiple items share the same date, list them on separate lines with 10-space indent for the second and subsequent items:
```
  Apr 19  ●  First item
          ●  Second item
```

### Step 6: Draft the Detailed Change Log section

Format each entry under a `### YYYY-MM-DD` header with `**Type:**` and `**Scope:**` fields followed by bullet points. Use bold category labels followed by bullet points. Keep descriptions factual and specific — include filenames, key findings, and produced artifacts. Mirror the style of existing entries in `Agent-Change-Log.md` closely.

### Step 7: Present the draft to the user

Show the drafted timeline line(s) and Detailed Change Log section. Ask:

> "Does this look right? Reply with any corrections, or confirm to append."

Wait for confirmation before writing.

### Step 8: Write the changes

**Update the timeline:**
Use Edit to insert the new separator and date line(s) at the bottom of the timeline block, before the closing ` ``` ` fence.

**Update the Detailed Change Log:**
Use Edit to insert the new `### YYYY-MM-DD` section immediately before the `*This file is updated by…*` footer line.

### Step 9: Confirm

Tell the user:
- The date entry added
- How many categories were logged
- File updated: `Agent-Change-Log.md`
