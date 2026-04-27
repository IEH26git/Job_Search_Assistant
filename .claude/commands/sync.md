---
description: Mid-day sync - review daily note, update memory, prune stale items
argument-hint: ""
allowed-tools:
  - Read
  - Edit
  - Glob
  - Grep
  - Bash(date:*)
---

Sync memory with current daily log and process any new meeting transcripts. Use mid-day or whenever context needs refreshing.

## Source Files

- **Memory**: `$PWD/.claude/memory.md`
- **Daily Log**: `$PWD/Daily Notes/YYYY-MM-DD-Daily Log.md`
- **Meetings Folder**: `$PWD/Meetings/`
- **Scratchpad**: `$PWD/Scratchpad.md`
- **Priorities Reference**: `$PWD/Templates/job-search-priorities.md`

---

## Steps

### Step 1: Get today's date

Determine today's date in YYYY-MM-DD format (e.g., 2026-02-16).

### Step 2: Read current state

Read:
1. Today's Daily Log (`Daily Notes/YYYY-MM-DD-Daily Log.md`)
2. Current Memory file
3. Scratchpad

### Step 3: Process unprocessed meetings

Scan the Meetings folder for any files with `status: unprocessed` in frontmatter.

For each unprocessed meeting:
1. Read the Raw Transcript section
2. Generate and fill in:
   - **Summary**: 2-4 sentence overview
   - **Action Items**: Bulleted list with owners if mentioned
   - **Key Points**: Important decisions, insights, information
3. Update frontmatter: `status: processed`
4. **Rename the file** to: `YYYY-MM-DD [Meeting Title].md`
   - Use date from frontmatter
   - Extract title from heading or create from summary
   - Use `mv` command to rename
5. Add to Daily Log under `## Meetings & Conversations`:
   - Format: `- [[Meeting Note Name]]: [one-line summary]`
   - Use the NEW filename (without .md) in wiki link
6. **ASK**: "Any action items from [meeting] you want moved to the Task Board?"
   - Do NOT auto-add action items
   - Only add if explicitly requested
   - Task Board is for needle-moving items only

### Step 4: Process Scratchpad

Read the Scratchpad. For each item:
1. **Tasks/todos** → Ask if they should go to Task Board Inbox
2. **Ideas/thoughts** → Add to Daily Log under Notes, or promote to Memory (Parked)
3. **Context/decisions** → Promote to Memory (appropriate section)
4. **Links/references** → Add to Daily Log under Notes
5. **Ephemeral/done** → Discard

After processing, summarize what was captured and where.

**Note:** Do NOT clear the scratchpad during /sync - only /wrap-up clears it.

### Step 4b: Priority check

Read `Templates/job-search-priorities.md`.

1. Check for Tier 2 deadlines ≤5 days away — if found, flag:
   > "⚠️ BCG deadline in X days — Tier 2 items should be in Today"
2. Check if any dependency in the Known Dependency Chains has been resolved since the last session. If the upstream task was completed today, flag the newly unblocked downstream:
   > "✅ Portfolio site launched — Jennifer Ives outreach is now unblocked"
3. If a constraint in Active Constraints has been resolved (e.g., BCG application submitted), update `job-search-priorities.md` to reflect the new state.
4. Skip silently if nothing has changed.

### Step 5: Identify what to promote

Review Daily Log and Scratchpad for things to add to memory:
- Important decisions → Recent Decisions
- Open questions/blockers → Open Threads
- Ideas to revisit later → Parked
- People context learned → People & Context
- Priority shifts → Now

### Step 6: Identify what to prune

Review Memory for items that are:
- **Resolved** → Remove from Open Threads
- **No longer relevant** → Remove entirely
- **Completed decisions older than 2 weeks** → Remove from Recent Decisions
- **Stale parked items** → Promote to Open Threads or remove

### Step 7: Update memory

Edit the Memory file:
- Add new items (concise, one line each)
- Remove resolved/stale items
- Update "Now" section if priorities shifted
- **Keep total under ~100 lines**

### Step 8: Check CAIO outreach targets

Read `CAIO-Targets.md`. Find any rows where:
- **Next Step Date** contains a date that is today or earlier
- **Status** is not `Closed`

If any are due, surface them:
> "CAIO outreach due: [Name] @ [Company] — [Next Step]"

If none are due, skip silently.

### Step 8b: Check application follow-ups

Read `Progress Log.md`. In the **Jobs applied for** table, find any rows where:
- The **Follow-Up** column contains a date (not `—`)
- That date is today or earlier
- The **Status** does not indicate a terminal state (e.g., "Closed", "Rejected", "Offer accepted", "Withdrawn")

If any overdue follow-ups exist, surface them:
> "Follow-up overdue: [Company] — [Role] (was due [date])"

If none are overdue, skip silently.

### Step 9: Report

Tell the user:
- Scratchpad items processed (if any)
- Meetings processed (if any)
- What was added to memory
- What was removed/pruned
- Current state of memory (brief summary)
- Overdue application follow-ups (if any, already surfaced above)
- CAIO outreach actions due (if any, already surfaced above)

---

## Memory Maintenance Rules

- Each bullet point should be ONE concise line
- Use format: `- Topic: status/context` for Open Threads
- Use format: `- [YYYY-MM-DD] Decision: rationale` for Recent Decisions
- If a section is empty, leave just `-` as placeholder
- Aggressively prune - memory is for ACTIVE context, not history
