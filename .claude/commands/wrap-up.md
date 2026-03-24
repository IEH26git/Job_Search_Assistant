---
description: End of day - sync memory, clear done list, prep for tomorrow
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash(date:*)
  - Bash(mv:*)
  - Bash(mkdir:*)
  - Bash(git:*)
---

End of day wrap-up. Syncs memory, clears completed tasks, and preps for tomorrow.

## Source Files

- **Memory**: `/Users/ianheiman/Desktop/PublicTest/.claude/memory.md`
- **Daily Log**: `/Users/ianheiman/Desktop/PublicTest/Daily Notes/YYYY-MM-DD-Daily Log.md`
- **Task Board**: `/Users/ianheiman/Desktop/PublicTest/Task Board.md`
- **Scratchpad**: `/Users/ianheiman/Desktop/PublicTest/Scratchpad.md`
- **Meetings Folder**: `/Users/ianheiman/Desktop/PublicTest/Meetings/`
- **Weekly Summary Template**: `/Users/ianheiman/Desktop/PublicTest/Templates/Weekly Summary Template.md`
- **Weekly Summaries Folder**: `/Users/ianheiman/Desktop/PublicTest/Weekly Summaries/`
- **Progress Log**: `/Users/ianheiman/Desktop/PublicTest/Progress Log.md`

---

## Steps

### Step 1: Get today's date

Determine today's date in YYYY-MM-DD format (e.g., 2026-02-16).
Also determine the day of the week.

### Step 2: Read current state

Read:
1. Today's Daily Log
2. Current Memory file
3. Task Board
4. Scratchpad

### Step 3: Process unprocessed meetings

Scan the Meetings folder for any files with `status: unprocessed` in frontmatter.

For each unprocessed meeting:
1. Read the Raw Transcript section
2. Generate and fill in:
   - **Summary**: 2-4 sentence overview
   - **Action Items**: Bulleted list with owners
   - **Key Points**: Important decisions, insights, information
3. Update frontmatter: `status: processed`
4. **Rename the file** to: `YYYY-MM-DD [Meeting Title].md`
   - Use date from frontmatter
   - Extract title from heading or create from summary
   - Use `mv` command to rename
5. Add to Daily Log under `## Meetings & Conversations`:
   - Format: `- [[Meeting Note Name]]: [one-line summary]`
6. **ASK**: "Any action items from [meeting] you want moved to the Task Board?"
   - Do NOT auto-add action items

### Step 4: Sync memory

Review Daily Log for items to promote to memory:
- Important decisions → Recent Decisions
- Open questions/blockers → Open Threads
- Ideas to revisit → Parked
- People context → People & Context
- Priority shifts → Now

Review Memory for items to prune:
- Resolved items → Remove
- Stale items → Remove
- Old decisions (2+ weeks) → Remove

Update Memory file, keeping under ~100 lines.

### Step 5: Process and clear Scratchpad

Read the Scratchpad. For each item:
1. **Unfinished tasks/todos (Job Search or Learning)** → Move to Task Board (Soon or Today); do not discard
2. **Completed tasks** → Note as Progress Log candidates; discard from scratchpad
3. **Ideas/thoughts** → Add to Daily Log under Notes, or promote to Memory
4. **Context/decisions** → Promote to Memory
5. **Links/references** → Add to Daily Log under Notes
6. **Ephemeral/done (Household, Personal)** → Discard

**Before clearing, extract all URLs:**
- Scan every scratchpad item for hyperlinks (markdown or plain URLs)
- Save each URL to the Daily Log under `## Notes`, associated with its context
- Format: `- [Label](URL) — [brief context]`
- Do not discard any URL, even if the surrounding text seems ephemeral

After processing, **clear the scratchpad** by resetting it to:
```
# Scratchpad

Quick capture zone. Jot anything here throughout the day.
Processed during `/sync` and `/wrap-up`, then cleared.

---

```

### Step 6: Move completed tasks and manage Done list

Edit the Task Board:
1. Find all checked items in Today section (`- [x]`)
2. Move them to Done section (remove checkbox, use regular bullets)
3. Remove the checked items from Today section

**If Friday:**
- Do NOT clear Done yet — first generate the weekly summary (Step 7)

**If not Friday:**
- Leave Done items in place (visible through the week)

### Step 7: Generate Weekly Summary (Fridays only)

**Skip this step if today is not Friday.**

If today is Friday:

1. Determine this week's Monday date (YYYY-MM-DD)
2. Read the Weekly Summary Template
3. Read all daily logs from this week (`Daily Notes/YYYY-MM-DD-Daily Log.md` for Monday through Friday)
4. Read the Task Board Done section (before clearing)
5. Compile the weekly summary:
   - **Accomplishments**: Everything from Done list + key items from daily logs
   - **Key Decisions**: Pull from daily log Decisions sections and memory Recent Decisions
   - **Meetings & Conversations**: Aggregate from daily logs
   - **Open Items Carried Forward**: Unchecked Today/Soon items, Open Threads from memory
   - **Notes**: Anything notable from the week
6. Replace `{{MONDAY_DATE}}` with this week's Monday date
7. Save to `Weekly Summaries/Week of YYYY-MM-DD.md` (using Monday's date)
8. **Now** clear the Done section on the Task Board
9. Tell user: "Weekly summary saved. Done list cleared for the week."

### Step 8: Update Progress Log

Read the Progress Log and today's Daily Log.

Review today's work for milestone-quality items worth recording — things like:
- Applications submitted or roles applied to
- Key networking conversations or introductions
- Decisions about direction or strategy
- New skills developed or certifications started
- Tools or systems built that advance the search
- Interviews scheduled or completed

**ASK**: "Anything from today worth adding to the Progress Log?" and suggest candidates if you see any.

If the user confirms items, add them under the current week's heading (create a new week heading if needed). Keep entries concise — one line each.

**IMPORTANT:** Only append new entries. Never rewrite, reorganize, or modify existing Progress Log content — the user may edit this file directly.

### Step 9: Update Daily Log summary

If the "End of Day Summary" section is empty:
- Add a brief 1-2 sentence summary of what was accomplished
- Note any important carry-overs for tomorrow

### Step 10: Preview tomorrow

Check if anything needs attention tomorrow:
- Deadlines approaching?
- Waiting items that need follow-up?
- High priority items in Soon?

If yes, mention: "Tomorrow: keep an eye on [X]"

### Step 11: Commit and push to GitHub

1. Stage all changes:
```bash
git -C /Users/ianheiman/Desktop/PublicTest add .
```

2. Generate a summary of what changed:
```bash
git -C /Users/ianheiman/Desktop/PublicTest diff --staged --name-status
```

3. Check for system file changes. A system file is any staged path matching:
   - `.claude/commands/*.md` (skill files)
   - `CLAUDE.md`
   - `.claude/settings.json` or `.claude/settings.local.json`
   - `*.sh` (shell scripts)

   If any system files appear in the staged diff:
   - Read `/Users/ianheiman/Desktop/PublicTest/Agent-Change-Log.md`
   - Append a new dated entry to the **bottom** of the Detailed Change Log section, using this format:

   ```markdown
   ### YYYY-MM-DD — [Brief Title]

   **Type:** [Enhancement / Bug Fix / New Skill / Infrastructure / Documentation]
   **Scope:** [affected skill(s) or file(s)]

   - [bullet describing each change — one bullet per system file modified]
   ```

   - Write the updated file back to disk. This ensures the Agent-Change-Log update is included in the same commit.

   If no system files changed, skip this sub-step silently.

Parse the output to build a short summary:
- Lines starting with `A` = added files
- Lines starting with `M` = modified files
- Lines starting with `D` = deleted files

Format the commit message as:
```
Wrap-up YYYY-MM-DD — N files changed: +added.md, ~modified.md, -deleted.md
```

Rules for the summary suffix:
- List added files with `+`, modified with `~`, deleted with `-`
- If there are more than 4 changed files total, summarize by count instead: `+2 added, ~3 modified`
- If nothing is staged ("nothing to commit"), skip the commit and push entirely — note it silently

3. Commit and push:
```bash
git -C /Users/ianheiman/Desktop/PublicTest commit -m "<generated message>"
git -C /Users/ianheiman/Desktop/PublicTest push
```

- If `push` fails, mention it briefly so Ian is aware.

### Step 12: Sign off

Tell the user:
- Meetings processed (if any)
- Scratchpad processed and cleared
- Completed tasks moved to Done
- Progress Log updated (if applicable)
- Weekly summary saved (if Friday)
- Done list status (cleared if Friday)
- Memory synced (what changed)
- Tomorrow preview (if applicable)
- Changes committed and pushed to GitHub (or "nothing to commit" if no changes)

### Step 13: Closing reminder

Remind Ian: "You can run `/extract-transcript YYYY-MM-DD` to pull a verbatim transcript for any session back to 2026-02-13."
- "Good night."

---

## Memory Maintenance Rules

- Each bullet point should be ONE concise line
- Use format: `- Topic: status/context` for Open Threads
- Use format: `- [YYYY-MM-DD] Decision: rationale` for Recent Decisions
- If a section is empty, leave just `-` as placeholder
- Aggressively prune - memory is for ACTIVE context, not history
- **Keep total under ~100 lines**
