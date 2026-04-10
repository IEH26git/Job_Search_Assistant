# Job Search Workflow

An end-to-end documented workflow for running a job search using this personal operating system.

---

## Overview

This system supports a structured job search with the following phases:

1. **Source** — Identify and capture job opportunities
2. **Evaluate** — Score against role criteria
3. **Apply** — Tailor resume and submit applications
4. **Follow Up** — Track status and maintain relationships
5. **Interview** — Prepare and debrief

---

## Daily Rhythm

| Command | When | What it does |
|:--------|:-----|:-------------|
| `/start` | Morning | Load memory, open task board, surface overdue follow-ups |
| `/sync` | Midday | Process scratchpad, update memory, triage new items |
| `/wrap-up` | End of day | Sync memory, update progress log, commit to GitHub |

---

## Sourcing — Capturing Job Postings

### From Email Digests (LinkedIn, Indeed, JobLeads, etc.)
1. Select job digest emails in Apple Mail
2. Run `/process-job-emails` — fetches posting URLs, evaluates against criteria, creates JD files
3. Review `Manual-Review-YYYY-MM-DD.md` for roles that couldn't be fetched automatically

### Collecting Links for Later Review
1. Select emails containing job posting links in Apple Mail
2. Run `/collect-links` — extracts all URLs with metadata and appends them to `REF/Links.md`
3. Use `REF/Links.md` as a reading list; manually save promising postings as JD files

Add the optional `delete` argument to either command to remove processed emails from your inbox:
```
/process-job-emails delete
/collect-links delete
```

### Manual Capture
Save a JD file directly to `Resume/JDs/` using this format:
```
--- Captured: YYYY-MM-DD HH:MM | Fit: [Strong Fit / Possible Fit / Not a Fit] ---
[Source](URL)

[Paste full job description text here]
```

---

## Evaluation — Fit Scoring

The `/process-job-emails` skill scores each posting automatically:

| Score | Criteria |
|:------|:---------|
| **Strong Fit** | Seniority matches + 3+ keywords + domain match + no exclusions |
| **Possible Fit** | Seniority close + 1–2 keywords + partial domain match |
| **Not a Fit** | Exclusion triggered, wrong seniority, or zero keywords |

Customize criteria in `Templates/Role_Search_Criteria.md`.

---

## Applying — Resume Tailoring

1. Have the JD file saved in `Resume/JDs/`
2. Run `/resume-tailor JD-Company-Role.md` — generates tailored Markdown resume
3. Review and edit the tailored resume in `Resume/Tailored/`
4. Run `/convert-resume Resume/Tailored/<filename>.md` — converts to DOCX
5. Submit the DOCX to the employer (or save DOCX as a PDF before submitting)

### Optional: Capability Statements
Run `/capability-statements JD-Company-Role.md` for first-person statements for cover letters or outreach.

### Drafting a Cover Letter
Claude can draft a cover letter from your tailored resume and JD. Paste this prompt directly in Claude Code:

```
Using my tailored resume at Resume/Tailored/[filename].md and the JD at Resume/JDs/[filename].md,
draft a cover letter in my voice. Three paragraphs: why I'm interested in this specific role and
company, what I bring that directly matches their needs, and a brief professional close. Keep it
under 350 words.
```

Review and edit the draft before sending. You can ask Claude to adjust tone, shorten specific sections, or emphasize different experience.

---

## Meetings & Conversations

Use the `Meetings/` folder to capture notes from recruiter calls, hiring manager interviews, and networking conversations.

### Creating a Meeting Note
1. Copy `Templates/Meeting Note Template.md` and rename it: `Meetings/YYYY-MM-DD-[Person or Company].md`
2. Fill in attendees, key points, and action items immediately after the call
3. Paste a raw transcript in the **Raw Transcript** section if you have one

### Processing During /sync
`/sync` reads any unprocessed meeting notes and:
- Surfaces action items to the task board
- Updates memory with new context (people, companies, open threads)
- Marks the note `status: processed`

You can also trigger this manually:
```
Read my meeting note from today and update my memory and task board with any action items.
```

---

## Follow-Up Tracking

Follow-ups are tracked in the **Jobs applied for** table in `Progress Log.md`.

- Set the **Follow-Up** column to a date 7–10 days after applying
- `/start` surfaces any rows where the Follow-Up date is today or earlier
- After each follow-up, push the date forward 7 days

---

## Interview Preparation & Debrief

### Before an Interview
Ask Claude to help you prepare directly:
```
I have an interview for [Role] at [Company] on [date]. Read the JD at Resume/JDs/[filename].md
and my tailored resume at Resume/Tailored/[filename].md. Give me: the 5 most likely interview
questions, a one-paragraph "why this role" answer in my voice, and 3 questions I should ask them.
```

### After an Interview
1. Create a meeting note in `Meetings/` with key points, what went well, and open questions
2. Run `/sync` or ask Claude directly:
   ```
   Read my interview note from today and update my memory and progress log with next steps
   and any follow-up dates.
   ```

---

## Content & Outreach

### Drafting LinkedIn Posts, Articles, or Networking Messages
Run `/draft-content` with a platform and rough notes:
```
/draft-content linkedin Notes on what I learned building AI agents this week
/draft-content blog I want to write about structured job search systems
```

Claude will apply the voice and platform rules defined in `Templates/content-rules.md`. Edit that file to set your preferred tone, length, and formatting rules.

### Outreach Messages
Ask Claude directly for networking or recruiter outreach:
```
Draft a short LinkedIn message to a recruiter at [Company]. I'm interested in their VP of AI
role. Keep it under 100 words, reference my background in AI strategy, and don't be sycophantic.
```

---

## Utilities

These skills are available on demand and not tied to a specific workflow phase.

| Command | When to use |
|:--------|:------------|
| `/log-session [slug]` | At the end of a working session to capture what was built, decided, or changed |
| `/extract-transcript [date]` | To produce a verbatim turn-by-turn log of a past Claude Code session |
| `/extract-cursor-transcript [date]` | Same, for Cursor agent sessions |
| `/for-the-record` | To save a specific portion of the current conversation to a dated Markdown file |

Example — saving a decision for later reference:
```
/for-the-record
```
Claude will ask which turns to include and write them to `REF/`.

---

## Reference Files

| File | Purpose |
|:-----|:--------|
| `Templates/Role_Search_Criteria.md` | Fit scoring rules — customize for your target roles |
| `Templates/job-search-priorities.md` | Tier definitions, dependency chains, active deadlines |
| `Progress Log.md` | Applications, interviews, milestones |
| `Resume/master-resume.md` | Source of truth for all tailored resumes |
| `Resume/JDs/` | Saved job descriptions |
| `Resume/Tailored/` | Tailored resume outputs |

---

## Beyond Job Search — Defining Your Own Agent

This personal operating system is one example of an **orchestrating agent**: a folder with a `CLAUDE.md` file that gives Claude a persistent role, a set of skills, and a workflow to follow. The job search focus is defined entirely by the contents of that folder — the `CLAUDE.md` instructions, the skill files in `.claude/commands/`, and the templates.

You can create a completely different agent at any time by:

1. Creating a new working folder anywhere on your machine
2. Adding a `CLAUDE.md` file that defines the agent's role, key files, and design principles
3. Adding `.claude/commands/` with skill files for the workflows you want
4. Opening Claude Code from that folder: `cd /path/to/new-folder && claude`

Examples of other agents you could define this way:
- A **research assistant** that tracks sources, drafts summaries, and maintains a reading list
- A **project manager** that runs standups, tracks decisions, and generates status reports
- A **writing coach** that maintains your voice rules, drafts content, and logs revision history
- A **learning log** that captures what you studied, surfaces spaced repetition prompts, and tracks progress

Each agent is fully isolated — its memory, skills, and context live in its own folder. You can run multiple agents on the same machine by opening Claude Code from different directories.

For guidance on writing effective `CLAUDE.md` files, designing skills, and Claude Code best practices, see the official documentation:

- **Claude Code overview and setup:** [https://docs.anthropic.com/en/claude-code](https://docs.anthropic.com/en/claude-code)
- **Building effective agents:** [https://docs.anthropic.com/en/docs/build-with-claude/agents](https://docs.anthropic.com/en/docs/build-with-claude/agents)
