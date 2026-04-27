# Agent Change Log

A chronological record of all changes to the personal operating system — skills, workflows, infrastructure, and automation.

---

## Timeline Overview

```
2026-FEB                                                        2026-MAR
  │                                                                 │
  ├─ 02/09  Baseline system                                         │
  │         (memory, task board, /start, /sync, /wrap-up)           │
  │                                                                 │
  ├─ 02/15  Daily notes + weekly summary                            │
  │                                                                 │
  ├─ 02/18  Resume automation                                       │
  │         (/resume-tailor, /convert-resume, /capability-          │
  │          statements, md-to-docx.py)                             │
  │                                                                 │
  ├─ 02/21  Session log format redesign (/log-session)              │
  │                                                                 │
  ├─ 02/22  Verbatim transcript extraction (/extract-transcript)    │
  │                                                                 │
  ├─ 02/23  DOCX formatting fixes + session naming (/rename)        │
  │                                                                 │
  ├─ 02/24  Task routing architecture                               │
  │         (Task Board triage, 3-bucket inbox model)               │
  │                                                                 │
  ├─ 02/25  /process-job-emails — design + first run                │
  ├─ 02/26  (continued: evaluation rubric, manual review)           │
  │                                                                 │
  ├─ 02/27  Workflow docs + follow-up tracking                      │
  │         (Job-Search-Workflow.md, Meetings/ pattern)             │
  │                                          ┌──────────────────────┤
  │                                          │                      │
  │                                          ├─ 03/02  /draft-content skill
  │                                          │
  │                                          ├─ 03/08  /collect-links + session naming
  │                                          │
  │                                          ├─ 03/18  GitHub integration
  │                                                    + permissions
  │                                                    + bug fixes (5 items)
  │                                                    + /for-the-record skill
  │                                                    + Agent-Change-Log.md
  │
  │                                          └─ 04/04  Deployment docs + setup improvements
  │                                                    (README overhaul, setup.sh Linux fix,
  │                                                     SAMPLE file headers, notes.sqlite removed)
  ──────────────────────────────────────────────────────────────────
  Apr  5  ●  Public release prep (LICENSE, CONTRIBUTING, README)
  ──────────────────────────────────────────────────────────────────
  Apr 10  ●  Workflow doc expansion + README reorganization
  ──────────────────────────────────────────────────────────────────
  Apr 27  ★  Dynamic path migration + 4 new skills added
          ·  All skills: hardcoded paths replaced with $PWD
          ·  New: /adapt-skill, /create-change-log, /update-change-log, /git-commit-push
```

---

## Detailed Change Log

### 2026-02-09 — Baseline System Created

**Type:** Foundation
**Scope:** Full system initialization

- Created core memory architecture: `.claude/memory.md` as active context
- Created `Task Board.md` as the primary work tracker
- Created `Scratchpad.md` for ephemeral quick capture
- Built three core workflow skills: `/start`, `/sync`, `/wrap-up`
- Established folder structure: `Daily Notes/`, `Weekly Summaries/`, `Meetings/`, `Templates/`, `TaskMgmt/`, `REF/`, `Content/`
- Created `Progress Log.md` as cumulative milestone tracker
- Established design principles: memory = active context, daily notes = history

---

### 2026-02-15 — Daily Note Convention & Weekly Summary

**Type:** Enhancement
**Scope:** `/start`, `/wrap-up`

- Formalized daily log naming convention: `YYYY-MM-DD-Daily Log.md`
- Added weekly summary generation to `/wrap-up` (Fridays only)

---

### 2026-02-18 — Resume Automation Infrastructure

**Type:** New Skills
**Scope:** Four new skills + Python script

- **`/resume-tailor [JD]`** — generates tailored résumé Markdown from master résumé + tailoring rules + target JD
- **`/capability-statements [JD]`** — transforms JD into first-person capability statements
- **`/convert-resume [.md]`** — converts Markdown résumé to DOCX using `Resume/md-to-docx.py`
- **`Resume/md-to-docx.py`** — Python script using `python-docx`

---

### 2026-02-21 — Session Log Format Redesign

**Type:** Enhancement
**Scope:** `/log-session`

- Redesigned `/log-session` output format: structured summary of every user prompt, Claude's actions, files created/modified, key decisions

---

### 2026-02-22 — Verbatim Transcript Extraction

**Type:** New Skill + Script
**Scope:** `/extract-transcript`, `extract-transcript.sh`

- Created **`/extract-transcript [date]`** skill — produces turn-by-turn verbatim transcripts from Claude Code JSONL session files
- Created `extract-transcript.sh` — parses JSONL files by date, outputs formatted `.md` verbatim logs

---

### 2026-02-23 — DOCX Formatting Fixes + Session Naming

**Type:** Bug Fix + Enhancement
**Scope:** `md-to-docx.py`, `/start`

- Fixed multiple DOCX formatting issues in `md-to-docx.py`
- Added session naming via `/rename` to the `/start` skill

---

### 2026-02-24 — Task Routing Architecture

**Type:** Enhancement
**Scope:** `Task Board.md`, workflow design

- Redesigned Task Board into three-bucket model: Inbox → Active → Done
- Added `Meetings/` processing pattern to `/sync`

---

### 2026-02-25–26 — /process-job-emails

**Type:** New Skill
**Scope:** `/process-job-emails`

- Built **`/process-job-emails [delete]`** — reads selected Apple Mail emails via AppleScript, evaluates job postings against role criteria, creates JD files
- Features: URL extraction, WebFetch, fit scoring, JD file generation, Manual Review files, email deletion queue

---

### 2026-02-27 — Workflow Documentation + Follow-Up Tracking

**Type:** Documentation + Enhancement
**Scope:** `Job-Search-Workflow.md`, `/sync`

- Created `Job-Search-Workflow.md` — end-to-end documented workflow
- Added follow-up tracking pattern to `/sync`

---

### 2026-03-02 — /draft-content Skill

**Type:** New Skill
**Scope:** `/draft-content`

- Built **`/draft-content [platform] [notes]`** — drafts platform-specific content (LinkedIn, Substack, blog) from rough notes

---

### 2026-03-08 — /collect-links Skill

**Type:** New Skill
**Scope:** `/collect-links`

- Built **`/collect-links [delete]`** — extracts URLs from selected Apple Mail emails, appends with metadata to `REF/Links.md`

---

### 2026-03-18 — GitHub Integration, Permissions, Bug Fixes, New Skills

**Type:** Infrastructure + Bug Fix + New Skills
**Scope:** Multiple

- **GitHub integration**: initialized git repo, created `.gitignore`, pushed to private GitHub repo
- **Permissions**: configured `settings.local.json` to reduce permission prompts during skill runs
- **`/wrap-up` auto-commit**: added auto-commit step with generated summary commit message
- **`/process-job-emails` bug fixes**:
  - Fixed sender matching: use `contains` not `is` in AppleScript (Mail returns full display name + address)
  - Fixed osascript heredoc syntax: use `<<EOF` not `<<'EOF'` (quoted form triggers security prompt)
- **`/for-the-record` skill**: interactively saves conversation turns to dated `.md` files
- **`Agent-Change-Log.md`**: created this file

---

### 2026-04-04 — Deployment Documentation + Setup Improvements

**Type:** Documentation + Bug Fix
**Scope:** `README.md`, `setup.sh`, SAMPLE files

- **`README.md`**: Added Claude Code install instructions (npm, Node.js prerequisite, auth step); expanded Windows section into two explicit paths (WSL recommended, native Windows via Git Bash); added "What to Do Yourself vs. What to Ask Claude" section with example conversations; reframed Apple Mail-only skills to direct users to ask Claude to adapt them; added "seed your memory" step before first run
- **`setup.sh`**: Fixed `sed -i ''` (macOS-only syntax) — now detects OS and uses `sed -i` on Linux
- **SAMPLE files**: Added instructional header to all six SAMPLE files identifying which template or skill each is based on and when to delete it
- **`notes.sqlite`**: Removed personal data file from repo root (was untracked)

---

### 2026-04-05 — Public Release Prep

**Type:** Infrastructure + Documentation
**Scope:** `LICENSE`, `CONTRIBUTING.md`, `README.md`, `setup.sh`

**Infrastructure**
- `LICENSE` — added MIT license file
- `CONTRIBUTING.md` — added contributing guidelines for public repo
- `README.md` — multiple rounds of updates preparing for public release; added TOC, reorganized platform sections, expanded Windows instructions

---

### 2026-04-10 — Workflow Doc Expansion + Folder Index Audit

**Type:** Documentation + Infrastructure
**Scope:** `Job-Search-Workflow.md`, `REF/`, folder indexes

**Documentation**
- `Job-Search-Workflow.md` — expanded to full agent reference doc covering end-to-end workflow
- `REF/Job-Search-Workflow-old.md` — archived previous version
- Removed `Job-Search-Workflow-v1.md` (superseded)
- Updated `_folder_index.md` files across multiple folders to reflect current state

---

### 2026-04-27 — Dynamic Path Migration + New Skills

**Type:** Skills Updated + New Skills
**Scope:** All `.claude/commands/*.md` skills, `.claude/commands/_folder_index.md`

**Skills updated**
- All 13 existing skills (`start`, `sync`, `wrap-up`, `process-job-emails`, `collect-links`, `resume-tailor`, `capability-statements`, `convert-resume`, `draft-content`, `log-session`, `extract-transcript`, `extract-cursor-transcript`, `for-the-record`) — replaced all hardcoded absolute paths with `$PWD` for dynamic path derivation; no personally identifiable paths remain in any skill file

**Skills installed**
- `adapt-skill.md` — adapts a skill file from another Claude Code agent for use in this agent; identifies project-specific references, rewrites paths and scope, writes to target agent's `.claude/commands/`, deletes source
- `create-change-log.md` — bootstraps `Agent-Change-Log.md` from scratch by compiling full git history into ASCII timeline + detailed entries
- `update-change-log.md` — appends new entries to `Agent-Change-Log.md` from git log since last entry
- `git-commit-push.md` — stages all changes, generates a summary commit message from the diff, commits, and pushes

---

*This file is updated by `/wrap-up` when system files (skills, CLAUDE.md, settings, scripts) are detected in the staged git diff.*
