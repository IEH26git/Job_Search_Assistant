---
description: Start the day - load memory, open task board, ready to work
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash(date:*)
  - Bash(ls:*)
  - Bash(mkdir:*)
---

Start the work day. Loads context and gets ready to work.

## Source Files

- **Memory File**: `/Users/ianheiman/Desktop/PublicTest/.claude/memory.md`
- **Daily Note Template**: `/Users/ianheiman/Desktop/PublicTest/Templates/Daily Note Template.md`
- **Task Board**: `/Users/ianheiman/Desktop/PublicTest/Task Board.md`
- **Daily Notes Folder**: `/Users/ianheiman/Desktop/PublicTest/Daily Notes/`
- **Priorities Reference**: `/Users/ianheiman/Desktop/PublicTest/Templates/job-search-priorities.md`

---

## Steps

### Step 1: Get today's date

Determine today's date in YYYY-MM-DD format (e.g., 2026-02-16).

### Step 2: Load Memory

Read the memory file.

If it has content in the "Now" or "Open Threads" sections, briefly surface the context:
- "Context from memory: [Now summary]"
- "Open threads: [list key items]"

If memory is empty/placeholder only, skip silently.

### Step 3: Create/Open Daily Log

Check if today's daily log exists at:
`Daily Notes/YYYY-MM-DD-Daily Log.md`

If it doesn't exist:
1. Read the template from `Templates/Daily Note Template.md`
2. Replace template variables:
   - `{{DATE}}` → YYYY-MM-DD (today's date)
3. Create the new daily log with the processed template

### Step 4: Open Task Board

Read the Task Board.

### Step 5: Task review — Today and next 2 weeks at a glance

Read `Templates/job-search-priorities.md`.

Display the board in this format every time, pulling directly from the Task Board:

```
TODAY (max 2)
- [item] — [target/note]

THIS WEEK (by Fri [date])
- T1 - [item] — by [day]
- T2 - [item] — by [day]
- T3 - ⛔ [item] [blocked: dependency]

NEXT WEEK (by Fri [date])
- T1 - [item] — by [day]
- T2 - [item] — by [day]
```

Rules:
- Flag blocked items with ⛔ and name the dependency
- Flag any item with a missed target date with ⚠️
- Check Active Constraints in job-search-priorities.md for hard deadlines to surface

Then:
1. **Inbox**: If any items exist, propose triage (Today / This Week / Next Week / Later / Clear). Ask: "Want me to apply this triage?" — do not move without confirmation.
2. **Today candidates**: If Today has fewer than 2 items, propose the highest-priority unblocked items from This Week to fill it (max 2 total). Ask: "Want me to move these to Today?" — do not move without confirmation.

### Step 5b: Check application follow-ups

Read `Progress Log.md`. In the **Jobs applied for** table, find any rows where:
- The **Follow-Up** column contains a date (not `—`)
- That date is today or earlier
- The **Status** does not indicate a terminal state (e.g., "Closed", "Rejected", "Offer accepted", "Withdrawn")

If any overdue follow-ups exist, surface them clearly:
> "Follow-up overdue: [Company] — [Role] (was due [date])"

If none are overdue, skip silently.

### Step 6: Ready to work

Summarize:
- Overdue application follow-ups (if any, from Step 5b)
- Daily Log location

Ask: "What do you want to tackle first?"

---

## Notes

- Be concise
- Focused, action-oriented
- Skip any section silently if its source file is empty
