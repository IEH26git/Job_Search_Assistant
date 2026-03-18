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

### From Email Digests (LinkedIn, Lensa, JobLeads, etc.)
1. Select job digest emails in Apple Mail
2. Run `/process-job-emails` — fetches posting URLs, evaluates against criteria, creates JD files
3. Review `Manual-Review-YYYY-MM-DD.md` for roles that couldn't be fetched automatically

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
5. Submit the DOCX to the employer

### Optional: Capability Statements
Run `/capability-statements JD-Company-Role.md` for first-person statements for cover letters or outreach.

---

## Follow-Up Tracking

Follow-ups are tracked in the **Jobs applied for** table in `Progress Log.md`.

- Set the **Follow-Up** column to a date 7–10 days after applying
- `/start` surfaces any rows where the Follow-Up date is today or earlier
- After each follow-up, push the date forward 7 days

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
