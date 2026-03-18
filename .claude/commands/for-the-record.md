---
description: Record a portion of the current conversation to a .md file for future reference
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Bash(date:*)
---

Save a portion of the current conversation to a markdown file for the record.

## Steps

### Step 1: Get today's date

Run `date` and format as `YYYY-MM-DD`.

### Step 2: Ask how many turns to include

Ask the user:

> "How many turns back should I include? (A turn = one user message + one Claude response. So 'last 4 turns' = the 4 most recent back-and-forth exchanges.)"

Wait for a response before proceeding.

### Step 3: Suggest a folder

Based on the content of the turns to be recorded, suggest the most appropriate folder:

- **`TaskMgmt/`** — session notes, how-to discussions, workflow decisions, tool/skill documentation
- **`REF/`** — reference material, explanations of concepts, things Ian will want to look up later
- **`Daily Notes/`** — reflections, personal notes, things tied to a specific day's work
- **`Content/`** — drafts, ideas for posts or writing

Tell the user your suggested folder and why, then ask: "Does that folder work, or would you like a different one?"

Wait for confirmation before proceeding.

### Step 4: Suggest a filename and ask for approval

Construct a suggested filename based on the date and the topic of the turns:

Format: `YYYY-MM-DD-<short-topic-slug>.md`

Example: `2026-03-18-context-window-and-compaction.md`

- Keep the slug short (3–5 words, hyphenated, no spaces)
- Derive the topic from the content, not a generic label

Tell the user: "Suggested filename: `<filename>`. Approve or tell me a different name."

Wait for confirmation before proceeding. If Ian provides an alternate name, use that exactly (add `.md` if not included).

### Step 5: Write the file

Write the file to `<folder>/<filename>` using this format:

```markdown
# <Title derived from topic>

Date: YYYY-MM-DD

---

**Ian:** <user message>

**Claude:** <Claude response>

---

**Ian:** <user message>

**Claude:** <Claude response>

---
```

Include exactly the number of turns confirmed in Step 2, starting from the most recent and going back. Preserve the full text of each message — do not summarize or truncate.

### Step 6: Update the folder index

Read `<folder>/_folder_index.md` and add an entry for the new file.

### Step 7: Confirm

Tell the user the full file path and how many turns were recorded.
