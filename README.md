# Personal Operating System — Claude Code

A personal productivity system built on [Claude Code](https://claude.ai/code) that automates your daily workflow, job search, and content creation through a suite of slash commands.

---

## What This Is

This is a **personal operating system** — a folder you open in Claude Code that gives you a structured daily workflow, persistent memory, and a library of custom skills. Everything is plain Markdown files that you can read, edit, and version-control.

**Core daily loop:**
```
/start   →   /sync   →   /wrap-up
```

---

## Prerequisites

- **[Claude Pro](https://claude.ai) or higher** — required for Claude Code CLI access
- **[Claude Code CLI](https://docs.anthropic.com/en/claude-code)** — the command-line interface this system runs on
- **Python 3** — for `/convert-resume` (resume → DOCX conversion)
- **`python-docx`** — Python library (installed in setup below)
- **macOS + Apple Mail** — required for `/process-job-emails` and `/collect-links`, which use AppleScript to read and delete emails

> **Adapting to your environment:** All skills are plain Markdown files in `.claude/commands/`. You can modify any skill to fit your tools and workflow. For example:
> - If you use Gmail instead of Apple Mail, adapt the AppleScript steps in `/process-job-emails` to use the Gmail API or another integration
> - If you don't need the resume skills, delete or ignore them
> - If you want to add new skills, create a `.md` file in `.claude/commands/` and it becomes a new `/command`

---

## Setup

### 0. Grab a markdown editor
AI tools use markdown files (.MD extension) **A LOT**. You don't need a markdown editor to use this personal operating system, but when you work with Claude Code, it really helps. 

    - **Windows** users: You can open .MD files in **Notepad**. 
    - **Mac** users: You can open .MD files in **TextEdit**.
    - **Linux** users: You can open .MD files in any text editor (nano, vim, emacs, etc.). 

*If you want,** you could also find and install a markdown editor to read them. In the end, they're just text files that follow some rendering rules. I use a Mac and these are my favorites: **typewriter**, **MarkEdit**, and **QOwnNotes** 
See the 'Markdown_Editors.md' file in the /REF folder for more information.

### 1. Clone this repo

```bash
git clone https://github.com/<username>/<repo-name> ~/Documents/my-personal-os
cd ~/Documents/my-personal-os
```

### 2. Run setup

```bash
chmod +x setup.sh
./setup.sh
```

The setup script will ask for the full path to this folder and replace `/Users/ianheiman/Desktop/PublicTest` throughout all skill files. Run this once after cloning.

### 3. Install Python dependencies

```bash
cd Resume
python3 -m venv .venv
.venv/bin/pip install python-docx
cd ..
```

### 4. Open in Claude Code

```bash
claude
```

Then run `/start` to begin.

---

## Folder Structure
These are the folders created in your chosen main/root folder.

```
.
├── .claude/
│   ├── commands/         # Skill definition files (slash commands)
│   └── memory.md         # Active context — read at /start, updated at /sync
├── Templates/            # Role criteria, priorities, voice rules, note templates
├── Resume/
│   ├── master-resume.md  # Source of truth for all tailored resumes
│   ├── md-to-docx.py     # Resume conversion script
│   ├── JDs/              # Saved job descriptions
│   └── Tailored/         # Generated tailored resume outputs
├── Daily Notes/          # One file per working day (auto-created by /start)
├── Meetings/             # Meeting transcripts and processed notes
├── Weekly Summaries/     # Friday wrap-up summaries (auto-created by /wrap-up)
├── TaskMgmt/             # Session logs and research notes
├── REF/                  # Reference materials and collected links
├── Content/              # Drafted posts and writing
├── Task Board.md         # Active work tracker (Today / This Week / Next Week / Later)
├── Progress Log.md       # Cumulative milestones (applications, interviews, decisions)
├── Scratchpad.md         # Ephemeral quick capture (cleared at /wrap-up)
└── Job-Search-Workflow.md  # End-to-end workflow documentation
```

---

## Skills (Slash Commands)

| Command | What it does |
|:--------|:-------------|
| `/start` | Morning startup — loads memory, creates daily log, reviews task board |
| `/sync` | Midday refresh — processes scratchpad and meetings, updates memory |
| `/wrap-up` | End-of-day — syncs memory, updates progress log, commits to GitHub |
| `/process-job-emails [delete]` | Reads selected Apple Mail emails, evaluates job postings, creates JD files |
| `/collect-links [delete]` | Extracts URLs from selected emails, saves to `REF/Links.md` |
| `/resume-tailor [JD]` | Generates tailored resume from master resume + rules + JD |
| `/capability-statements [JD]` | Transforms JD into first-person capability statements |
| `/convert-resume [.md]` | Converts Markdown resume to DOCX |
| `/draft-content [platform] [notes]` | Drafts LinkedIn, Substack, or blog content |
| `/log-session [slug]` | Generates structured session log |
| `/extract-transcript [date]` | Produces verbatim turn-by-turn transcript from Claude Code session logs |
| `/extract-cursor-transcript [date]` | Produces verbatim turn-by-turn transcript from Cursor agent session logs |
| `/for-the-record` | Saves recent conversation turns to a dated Markdown file |

Alias note: use `/extract-transcript` for Claude Code logs and `/extract-cursor-transcript` for Cursor logs.

---

## Customization

Start here to make the system your own:

| File | What to customize |
|:-----|:-----------------|
| `Templates/Role_Search_Criteria.md` | Target role titles, keywords, domains, exclusions for fit scoring |
| `Templates/job-search-priorities.md` | Financial runway, tier definitions, active deadlines |
| `Templates/content-rules.md` | Your voice and platform rules for `/draft-content` |
| `Resume/master-resume.md` | Your experience, skills, and education |
| `.claude/memory.md` | Seed with your current context before first `/start` |

---

## License

MIT — use, adapt, and share freely.
