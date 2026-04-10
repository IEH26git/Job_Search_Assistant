# Everything You Can Do With This Agent

A complete reference for the personal operating system — daily workflows, job search capabilities, content tools, and session utilities.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Daily Rhythm](#2-daily-rhythm)
   - 2.1 [/start — Morning Startup](#21-start--morning-startup)
   - 2.2 [/sync — Midday Refresh](#22-sync--midday-refresh)
   - 2.3 [/wrap-up — End of Day](#23-wrap-up--end-of-day)
3. [Job Search — Sourcing](#3-job-search--sourcing)
   - 3.1 [From Email Digests](#31-from-email-digests)
   - 3.2 [Collecting Links for Later Review](#32-collecting-links-for-later-review)
   - 3.3 [Manual Capture](#33-manual-capture)
4. [Job Search — Evaluation](#4-job-search--evaluation)
5. [Job Search — Applying](#5-job-search--applying)
   - 5.1 [Resume Tailoring](#51-resume-tailoring)
   - 5.2 [Capability Statements](#52-capability-statements)
   - 5.3 [Cover Letters](#53-cover-letters)
6. [Job Search — Meetings & Conversations](#6-job-search--meetings--conversations)
7. [Job Search — Follow-Up Tracking](#7-job-search--follow-up-tracking)
8. [Job Search — Interview Preparation & Debrief](#8-job-search--interview-preparation--debrief)
9. [Content & Outreach](#9-content--outreach)
   - 9.1 [Drafting Content](#91-drafting-content)
   - 9.2 [Outreach Messages](#92-outreach-messages)
10. [Session Utilities](#10-session-utilities)
    - 10.1 [/log-session](#101-log-session)
    - 10.2 [/extract-transcript](#102-extract-transcript)
    - 10.3 [/extract-cursor-transcript](#103-extract-cursor-transcript)
    - 10.4 [/for-the-record](#104-for-the-record)
11. [Reference Files](#11-reference-files)
12. [Beyond This Agent — Building Your Own](#12-beyond-this-agent--building-your-own)

---

## 1. Overview

This personal operating system supports structured work across multiple domains. The job search functionality is the primary focus, but the system also provides general-purpose content, session logging, and knowledge management tools.

The agent is context-aware: it reads memory at startup, surfaces overdue tasks and follow-ups, processes notes and meetings, and commits everything to GitHub at end of day.

---

## 2. Daily Rhythm

| Command | When | What it does |
|:--------|:-----|:-------------|
| `/start` | Morning | Load memory, open task board, surface overdue follow-ups |
| `/sync` | Midday | Process scratchpad and meeting notes, update memory, triage new items |
| `/wrap-up` | End of day | Sync memory, clear done list, generate weekly summary (Fridays), commit to GitHub |

### 2.1 `/start` — Morning Startup

Loads active context and prepares a focused work plan for the day.

**What it does:**
- Reads memory and surfaces current "Now" and "Open Threads" context
- Creates today's Daily Log from template if it doesn't exist yet
- Reads the Task Board and displays Today / This Week / Next Week with tier labels
- Flags blocked items (⛔) and missed target dates (⚠️)
- Proposes triage for any Inbox items — does not move them without confirmation
- Surfaces any application follow-ups due today or overdue from `Progress Log.md`
- Asks: "What do you want to tackle first?"

### 2.2 `/sync` — Midday Refresh

Processes anything that has accumulated since the morning and keeps memory current.

**What it does:**
- Reads the Daily Log, memory, and Scratchpad
- Processes any unprocessed meeting notes in `Meetings/`: generates summaries, action items, and key points; marks as processed; renames the file; links it in the Daily Log
- Asks about meeting action items before adding anything to the Task Board
- Processes Scratchpad items: routes tasks, ideas, decisions, links, and ephemera to appropriate destinations
- Does not clear the Scratchpad — only `/wrap-up` clears it
- Flags Tier 2 deadlines ≤5 days away and newly unblocked dependency chains
- Promotes and prunes memory to keep it under ~100 lines
- Surfaces overdue application follow-ups

### 2.3 `/wrap-up` — End of Day

Closes out the day, syncs everything, and commits to GitHub.

**What it does:**
- Processes any unprocessed meeting notes (same as `/sync`)
- Syncs memory: promotes decisions, open threads, and people context; prunes resolved and stale items
- Processes and clears the Scratchpad; preserves any URLs found in it to the Daily Log
- Moves checked (completed) Task Board items to the Done section
- **Fridays only:** Generates a weekly summary from all daily logs and the Done list; clears the Done section after saving the summary
- Reviews the day's work and suggests candidates for the Progress Log — asks before adding anything
- Writes an End of Day Summary to the Daily Log
- Previews any tomorrow deadlines or follow-ups
- Checks for system file changes (skill files, CLAUDE.md) and appends a dated entry to `Agent-Change-Log.md` if any are found
- Commits and pushes all changes to GitHub with a structured commit message

---

## 3. Job Search — Sourcing

### 3.1 From Email Digests

Process job digest emails (LinkedIn, Indeed, JobLeads, etc.) directly from Apple Mail.

1. Select job digest emails in Apple Mail
2. Run `/process-job-emails` — fetches posting URLs, evaluates each against your role criteria, and creates JD files in `Resume/JDs/`
3. Review `Manual-Review-YYYY-MM-DD.md` for any roles that couldn't be fetched automatically

### 3.2 Collecting Links for Later Review

Capture links from emails without evaluating them immediately.

1. Select emails containing job posting links in Apple Mail
2. Run `/collect-links` — extracts all URLs with metadata and appends them to `REF/Links.md`
3. Use `REF/Links.md` as a reading list; manually save promising postings as JD files

**Optional delete argument:** Add `delete` to either command to remove processed emails from your inbox after processing:
```
/process-job-emails delete
/collect-links delete
```

### 3.3 Manual Capture

Save a JD file directly to `Resume/JDs/` using this format:
```
--- Captured: YYYY-MM-DD HH:MM | Fit: [Strong Fit / Possible Fit / Not a Fit] ---
[Source](URL)

[Paste full job description text here]
```

---

## 4. Job Search — Evaluation

The `/process-job-emails` skill scores each posting automatically against your criteria:

| Score | Criteria |
|:------|:---------|
| **Strong Fit** | Seniority matches + 3+ keywords + domain match + no exclusions |
| **Possible Fit** | Seniority close + 1–2 keywords + partial domain match |
| **Not a Fit** | Exclusion triggered, wrong seniority, or zero keywords |

Customize scoring criteria in `Templates/Role_Search_Criteria.md`.

---

## 5. Job Search — Applying

### 5.1 Resume Tailoring

1. Have the JD file saved in `Resume/JDs/`
2. Run `/resume-tailor JD-Company-Role.md` — generates a tailored Markdown resume from your master resume
3. Review and edit the output in `Resume/Tailored/`
4. Run `/convert-resume Resume/Tailored/<filename>.md` — converts the Markdown file to DOCX
5. Submit the DOCX (or save as PDF before submitting)

### 5.2 Capability Statements

Run `/capability-statements JD-Company-Role.md` to generate first-person capability statements mapped to the JD. Useful for cover letters, outreach messages, and LinkedIn summaries.

### 5.3 Cover Letters

Ask Claude directly — no slash command needed:

```
Using my tailored resume at Resume/Tailored/[filename].md and the JD at Resume/JDs/[filename].md,
draft a cover letter in my voice. Three paragraphs: why I'm interested in this specific role and
company, what I bring that directly matches their needs, and a brief professional close. Keep it
under 350 words.
```

Review and edit before sending. Ask Claude to adjust tone, shorten sections, or shift emphasis as needed.

---

## 6. Job Search — Meetings & Conversations

Use the `Meetings/` folder to capture recruiter calls, hiring manager interviews, and networking conversations.

**Creating a meeting note:**
1. Copy `Templates/Meeting Note Template.md` and rename: `Meetings/YYYY-MM-DD-[Person or Company].md`
2. Fill in attendees, key points, and action items immediately after the call
3. Paste a raw transcript in the **Raw Transcript** section if you have one
4. Leave frontmatter as `status: unprocessed`

**Automatic processing:** `/sync` and `/wrap-up` scan for unprocessed meeting notes and:
- Generate a summary, action items, and key points
- Mark the note `status: processed` and rename the file
- Link the note in the Daily Log
- Ask (but never assume) whether action items should go to the Task Board

**Manual trigger:**
```
Read my meeting note from today and update my memory and task board with any action items.
```

---

## 7. Job Search — Follow-Up Tracking

Follow-ups are tracked in the **Jobs applied for** table in `Progress Log.md`.

- Set the **Follow-Up** column to a date 7–10 days after applying
- `/start` and `/sync` surface any rows where the Follow-Up date is today or earlier (excluding terminal statuses)
- After each follow-up, push the date forward 7 days

---

## 8. Job Search — Interview Preparation & Debrief

### Before an Interview

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

## 9. Content & Outreach

### 9.1 Drafting Content

Run `/draft-content` with a platform and rough notes:
```
/draft-content linkedin Notes on what I learned building AI agents this week
/draft-content substack I want to write about structured job search systems
/draft-content blog How I use Claude Code as a personal operating system
```

Claude reads `Templates/content-rules.md` to apply your voice, platform conventions, and positioning themes. It also checks `Resume/master-resume.md` for concrete facts to ground the draft. The output is saved to `Content/` and displayed inline for review.

Edit `Templates/content-rules.md` to set your preferred tone, length limits, topics to avoid, and platform-specific rules.

### 9.2 Outreach Messages

Ask Claude directly — no slash command needed:
```
Draft a short LinkedIn message to a recruiter at [Company]. I'm interested in their VP of AI
role. Keep it under 100 words, reference my background in AI strategy, and don't be sycophantic.
```

---

## 10. Session Utilities

These commands are available on demand and are not tied to the job search workflow.

### 10.1 `/log-session`

Generates a structured log of the current conversation and saves it to `TaskMgmt/`.

```
/log-session
/log-session resume-agent
/log-session task-board-refactor
```

The log includes every user prompt verbatim (as blockquotes), a prose description of Claude's actions and decisions for each prompt, and a summary of files created, modified, or renamed during the session.

Optional slug argument produces a named file (`YYYY-MM-DD-<slug>.md`); without it, uses the date alone.

### 10.2 `/extract-transcript`

Produces a verbatim turn-by-turn conversation log for a past Claude Code session, pulled from local JSONL session files.

```
/extract-transcript 2026-03-18
/extract-transcript          ← defaults to today
```

The output includes every message in the session exactly as sent and received. Sessions are available back to 2026-02-13.

### 10.3 `/extract-cursor-transcript`

Same as `/extract-transcript`, but for Cursor agent sessions.

```
/extract-cursor-transcript 2026-03-18
```

### 10.4 `/for-the-record`

Saves a specific portion of the current conversation to a dated Markdown file — useful for preserving a decision, explanation, or reference material without logging the entire session.

```
/for-the-record
```

Claude will ask:
1. How many turns back to include
2. Which folder the content belongs in (`TaskMgmt/`, `REF/`, `Daily Notes/`, or `Content/`)
3. A suggested filename — you can approve or rename it

The file is written with each turn labeled `**User:**` / `**Claude:**` and the full text preserved without truncation. The folder index is updated automatically.

---

## 11. Reference Files

| File | Purpose |
|:-----|:--------|
| `Templates/Role_Search_Criteria.md` | Fit scoring rules — customize for your target roles |
| `Templates/job-search-priorities.md` | Tier definitions, dependency chains, active deadlines |
| `Templates/content-rules.md` | Voice, tone, and platform conventions for content drafts |
| `Progress Log.md` | Applications, interviews, milestones |
| `Resume/master-resume.md` | Source of truth for all tailored resumes |
| `Resume/JDs/` | Saved job descriptions |
| `Resume/Tailored/` | Tailored resume outputs |
| `Agent-Change-Log.md` | Dated log of all changes to skill files and system configuration |
| `REF/Links.md` | Collected links from email, populated by `/collect-links` |

---

## 12. Beyond This Agent — Building Your Own

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
