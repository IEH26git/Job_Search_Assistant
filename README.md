# Job_Search_Assistant using Claude Code
This personal productivity/operating system is built with and runs in [Claude Code](https://claude.ai/code). That means you have amazing capabilities available to automate your daily workflow, job search activities, and content creation while you learn about other things that Claude Code can do.

This **system** (also known as an *"orchestrating agent"*) runs in a folder you open in Claude Code. Doing so allows you to use a structured daily workflow, with persistent memory, and a library of custom skills. 

## [Everything You Can Do With This Agent](Job-Search-Workflow.md)
1. Overview
2. Daily Rhythm    
3. Job Search - Sourcing 
4. Job Search - Evaluation  
5. Job Search - Applying
6. Job Search - Meetings & Conversations  
7. Job Search - Follow-Up Tracking  
8. Job Search - Interview Preparation & Debrief  
9. Content & Outreach  
10. Session Utilities  
11. Reference Files  
12. Beyond This Agent → Building Your Own  

## Required tools for using this agent
- **[Claude Pro](https://claude.ai) license or higher** — required for Claude Code CLI access (sign up before installing Claude Code)
- **[Claude Code CLI](https://claude.ai/code)** — the command-line interface this system runs on (install instructions below)
- **Node.js 18+** — required to install Claude Code (install instructions below)
- **Python 3** — for `/convert-resume` (resume → DOCX conversion // install instructions below)
- **`python-docx`** — Python library (installed via setup script in a step below)

---

## Before you begin setup

### **macOS + Apple Mail Users** 
Everything in this repo works as shipped.

### **Windows + other email Users** — choose _one_ of the following paths (you don't need both)
  
**Path A: WSL** *(Recommended)*
Installing WSL gives you a full Linux environment inside Windows. Do this:
1. Open **PowerShell as Administrator** and run:
   ```powershell
   wsl --install
   ```
2. Restart your computer when prompted.
3. Open the new **Ubuntu** app from the Start menu. Create a username and password when asked.
4. From inside the Ubuntu terminal, continue with the rest of this guide exactly as written.

**Path B: Native Windows** *(no WSL)*
If you prefer to stay in Windows without WSL:
1. Install **Node.js** from [nodejs.org](https://nodejs.org) (Windows LTS installer).
2. Install **Git for Windows** from [git-scm.com](https://git-scm.com) — this also installs **Git Bash**, which you need to run `setup.sh`.
3. Run all terminal commands in **Git Bash** (not PowerShell or cmd.exe).
4. When installing Python dependencies (Step 3 below), use `.venv\Scripts\pip` instead of `.venv/bin/pip`.

---

## Setup the system/agent
### 1. Clone this repo  
Enter the following commands in your terminal:
```bash
git clone https://github.com/IEH26git/Job_Search_Assistant <~/Documents/my-personal-os>
cd <~/Documents/my-personal-os>
```
**IMPORTANT** - "<~/Documents/my-personal-os>" is a placeholder (within angle brackets) for the path for the folder you have chosen in which to run this system (i.e., [Your-Chosen-Folder]). Replace the placeholder for [Your-Chosen-Folder] in the command above with the actual path for [Your-Chosen-Folder].

#### Folder Structure
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

##### FYI - Recent Updates
**Skills installed 2026-04-27:**                                                               
  - `adapt-skill.md` — adapts a skill file from another Claude Code agent for use in this agent; identifies project-specific references, rewrites
  paths and scope, writes to target agent's `.claude/commands/`, deletes source                                                                     
  - `create-change-log.md` — bootstraps `Agent-Change-Log.md` from scratch by compiling full git history into ASCII timeline + detailed entries
  - `update-change-log.md` — appends new entries to `Agent-Change-Log.md` from git log since last entry                                             
  - `git-commit-push.md` — stages all changes, generates a summary commit message from the diff, commits, and pushes

### 2. Run the setup script
**Enter the following commands in your terminal before opening Claude Code:** 
```bash
chmod +x setup.sh
./setup.sh
```
The skill files contain hardcoded paths that must be updated to match your machine's environment, so the setup script will ask for the full path to [Your-Chosen-Folder] and replace the original author's path throughout all skill files. You only need to run this once after cloning the repo (step 1).

### 3. Install Python dependencies
In [Your-Chosen-Folder], enter the following commands in your terminal:
```bash
cd Resume
python3 -m venv .venv
.venv/bin/pip install python-docx   # Use this line for macOS / Linux
# .venv\Scripts\pip install python-docx   # Use this line for Windows (for WSL: use the line above)
cd ..
```

### 4. Customize your templates
Before launching Claude Code for the first time, fill in a few files so the agent has context about you:

| File | What to add |
|:-----|:-----------|
| `.claude/memory.md` | Your current focus, active projects, open threads — this is what the agent reads at the start of every session |
| `Resume/master-resume.md` | Your work history, skills, and education |
| `Templates/Role_Search_Criteria.md` | Target roles, keywords, and deal-breakers for job fit scoring |
| `Templates/job-search-priorities.md` | Financial runway, tier definitions, active deadlines |
| `Templates/content-rules.md` | Your writing voice and platform preferences |

You don't need to fill everything in before starting — you can add context as you go. But at minimum, seed `.claude/memory.md` with what you're working on right now.

### 5. Install and open Claude Code
Install Claude Code by entering the following command in your terminal (any command line interface (CLI)):
```bash
npm install -g @anthropic-ai/claude-code
```
If you run that 'npm' command and get an error, it may be because you don't have Node.js installed. Install it from [nodejs.org](https://nodejs.org) (LTS version recommended) and then try the 'npm install' command again.

Once installed, enter the following commands in your terminal to open Claude Code:
```bash
cd ~/Documents/my-personal-os   # change your directory/folder to wherever you cloned the repo ([Your-Chosen-Folder])
claude
```
The first time you open Claude Code, you will be guided to open a browser to authenticate with your Anthropic account. You need a **Claude Pro subscription or higher.** 

Once logged in (authenticated), Claude Code opens an interactive chat in your terminal. This is where you type commands.

### 6. Run `/start`
In the Claude Code chat prompt, type:
```
/start
```  
This is an example of a **slash command** — a shortcut that triggers a pre-written skill. Claude Code reads the skill definition from `.claude/commands/start.md` and executes it. You can see all available commands by typing `/` and browsing the list, or by looking at the Skills table below.

#### Skills (Slash Commands) in this system

| Command | What it does |
|:--------|:-------------|
| `/start` | Morning startup — loads memory, creates daily log, reviews task board |
| `/sync` | Midday refresh — processes scratchpad and meetings, updates memory |
| `/wrap-up` | End-of-day — syncs memory, updates progress log, commits to GitHub |
| `/process-job-emails [delete]` | Reads selected Apple Mail emails, evaluates job postings, creates JD files *(macOS + Apple Mail — ask Claude to adapt for other platforms)* |
| `/collect-links [delete]` | Extracts URLs from selected emails, saves to `REF/Links.md` *(macOS + Apple Mail — ask Claude to adapt for other platforms)* |
| `/resume-tailor [JD]` | Generates tailored resume from master resume + rules + JD |
| `/capability-statements [JD]` | Transforms JD into first-person capability statements |
| `/convert-resume [.md]` | Converts Markdown resume to DOCX |
| `/draft-content [platform] [notes]` | Drafts LinkedIn, Substack, or blog content |
| `/log-session [slug]` | Generates structured session log |
| `/extract-transcript [date]` | Produces verbatim turn-by-turn transcript from Claude Code session logs |
| `/extract-cursor-transcript [date]` | Produces verbatim turn-by-turn transcript from Cursor agent session logs |
| `/for-the-record` | Saves recent conversation turns to a dated Markdown file |

Alias note: use `/extract-transcript` for Claude Code logs and `/extract-cursor-transcript` for Cursor logs (if you use Cursor as an IDE).

> **How slash commands work:** Every `.md` file in `.claude/commands/` becomes a `/command` you can call by name. The file describes what Claude should do — read files, ask questions, write output. You can edit any skill or create new ones just by asking Claude for what you want.

**Core daily commands loop:**
```
/start   →   /sync   →   /wrap-up
```
See **Job-Search-Workflow.md** for detailed instructions on how to use this system and modify it. 
See **Agent-Change-Log.md** for a history of how features have been added and evolved.

### 7. Select your markdown editor
AI tools use markdown files (.MD extension) **A LOT**. You don't need a markdown editor to use this system, but when you work with Claude Code, it really helps. 

- **Windows users:** You can open .MD files in **Notepad**.
- **Mac users:** You can open .MD files in **TextEdit**.
- **Linux users:** You can open .MD files in any text editor (nano, vim, emacs, etc.). 

*If you want,* you could also find and install a markdown editor to read them. In the end, they're just text files that follow some format rendering rules. The author uses a Mac and these are his favorites: **typewriter**, **MarkEdit**, and **QOwnNotes** 
See the 'Markdown_Editors.md' file in the REF/ folder for more information.

---

## What to Do Yourself vs. What to Ask Claude
Some tasks require you to act directly in your terminal or editor — Claude can't do these for you. Others are best delegated to Claude from inside the system once it's running.

### Do these yourself
These are one-time setup steps that happen outside the agent:

| Task | How |
|:-----|:----|
| Clone the repo | `git clone ...` in your terminal |
| Run `setup.sh` | `./setup.sh` in your terminal, before opening Claude Code |
| Fill in `.claude/memory.md` | Open the file in any text editor; add your current focus and open threads |
| Fill in `Resume/master-resume.md` | Paste in your work history and skills |
| Fill in `Templates/Role_Search_Criteria.md` | Add target roles, keywords, and deal-breakers |
| Open Claude Code | `claude` in your terminal from the repo folder |

### What to Ask Claude to Do
Once you're inside Claude Code, most configuration and customization tasks can be handed off. Skill files are plain Markdown — Claude can read and rewrite them just like any other file.

**Adapting built-in skills to your environment:**
> "I use Gmail instead of Apple Mail. Can you rewrite `/process-job-emails` to use the Gmail API instead of AppleScript?"

> "I'm on Windows and `/collect-links` uses AppleScript. Can you replace that with a version that reads emails from an `.eml` file I paste in?"

**Creating new skills:**
> "Create a new `/weekly-review` command that reads my last 5 daily notes and summarizes what I accomplished, what I didn't finish, and what to carry forward."

> "Add a `/standup` command that reads today's task board and drafts a 3-bullet standup message."

**Changing how existing skills behave:**
> "Update `/draft-content` so it always writes in a more casual, first-person tone and never uses bullet points."

> "Add a step to `/wrap-up` that asks me what I want to focus on tomorrow before it closes out."

**Seeding and updating your context:**
> "Read my notes from today and update my memory file with any new open threads or decisions."

> "I just accepted a job offer. Update the progress log and memory to reflect that."

**Remember:** Everything the agent knows and does is in plain text files you can open, read, and describe to Claude. If something doesn't fit your workflow, you don't need to figure it out yourself — just describe what you want.

---

## Customization
Key files to personalize:

| File | What to customize |
|:-----|:-----------------|
| `.claude/memory.md` | Your active context — projects, priorities, open threads |
| `Templates/Role_Search_Criteria.md` | Target role titles, keywords, domains, exclusions for fit scoring |
| `Templates/job-search-priorities.md` | Financial runway, tier definitions, active deadlines |
| `Templates/content-rules.md` | Your voice and platform rules for `/draft-content` |
| `Resume/master-resume.md` | Your experience, skills, and education |

---

Credit for initial baseline prompts and tutorial go to [Michael Crist](https://substack.com/home/post/p-184955320)

---

## License
MIT — use, adapt, and share freely.
