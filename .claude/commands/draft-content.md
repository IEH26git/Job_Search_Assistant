---
description: Draft platform-specific content (LinkedIn, Substack, blog) from rough notes or a topic prompt
argument-hint: "[platform: linkedin | substack | blog] [topic or rough notes]"
allowed-tools:
  - Read
  - Write
  - Bash(date:*)
---

Generate a polished content draft for a specific platform from Ian's rough notes or a topic prompt.

## Source Files

- **Content Rules**: `<WORKSPACE_PATH>/Templates/content-rules.md`
- **Master Resume**: `<WORKSPACE_PATH>/Resume/master-resume.md`
- **Output Folder**: `<WORKSPACE_PATH>/Content/`

---

## Steps

### Step 1: Load rules

Read `Templates/content-rules.md` in full. This defines Ian's positioning themes, voice, what to avoid, and platform-specific conventions.

### Step 2: Identify the platform and topic

Parse the argument:
- **First word** = platform (`linkedin`, `substack`, or `blog`)
- **Remaining text** = topic or rough notes

If no platform is provided, ask:
> "Which platform is this for — LinkedIn, Substack, or blog?"

Wait for the response before proceeding.

If the topic or notes are extremely thin (fewer than 5 words with no clear substance), ask one focused question to draw out a concrete example or angle:
> "Can you share a specific example or moment that prompted this? That will make the draft much stronger."

### Step 3: Load accomplishments (if relevant)

Scan `Resume/master-resume.md` for any specific accomplishments, projects, or facts that could strengthen the draft given the topic. Use these for grounding — don't invent details.

### Step 4: Generate the draft

Write a single draft for the specified platform, applying:
- The platform's length, structure, and tone conventions from content-rules.md
- At least one of Ian's four positioning themes, expressed concretely (not as a label)
- Ian's voice: direct, first-person, human, not boastful, concrete over abstract

### Step 5: Get today's date and construct filename

Run `date` to get today's date (YYYY-MM-DD format).

Construct a slug from 2–3 key words in the topic (kebab-case, lowercase). Examples:
- "AI workflow for job search" → `ai-workflow-job-search`
- "Lessons from applying to 8 roles" → `lessons-from-applying`

Output filename: `YYYY-MM-DD-[platform]-[slug].md`

### Step 6: Save and display

Write the draft to:
`<WORKSPACE_PATH>/Content/<filename>.md`

Display the full draft inline for review.

### Step 7: Confirm

Tell the user:
- The output file path
- Which positioning theme(s) the draft leans on and why
- Any note if the topic was thin and a stronger concrete example would improve a revision

---

## Notes

- Never invent facts or accomplishments — if a specific detail would help, surface the relevant bullet from the master resume or ask Ian for it
- Apply the platform conventions strictly: LinkedIn gets hashtags, Substack does not; Blog gets structure and depth
- If Ian wants a different angle or tone after seeing the draft, revise in the same session without re-reading the rules files
