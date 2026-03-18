# Claude Context

This is a personal operating system. Work from this directory.

## Quick Start
- Run `/start` to begin work
- Run `/sync` mid-day to refresh memory
- Run `/wrap-up` at end of day

## Key Files
- Memory: `.claude/memory.md` (read this for current context)
- Task Board: `Task Board.md`
- Scratchpad: `Scratchpad.md` (quick capture, processed during /sync, cleared at /wrap-up)
- Meetings: `Meetings/` (paste transcripts here, processed during /sync)
- Daily Notes: `Daily Notes/` (created automatically by /start, named `YYYY-MM-DD-Daily Log.md`)
- Weekly Summaries: `Weekly Summaries/` (generated Fridays by /wrap-up, named `Week of YYYY-MM-DD.md`)
- Progress Log: `Progress Log.md` (cumulative milestones; updated during /wrap-up)
- Templates: `Templates/`

## Memory Architecture
- **Memory** (`.claude/memory.md`): Active, living context
  - `/start` reads only
  - `/sync` reads and writes
  - `/wrap-up` reads and writes

## Design Principles
- Memory = active context, daily notes = history
- Task Board for needle-moving items only
- Meeting action items stay in meeting notes unless explicitly requested
- Scratchpad is ephemeral (cleared at end of day)
- Be concise
- For factual or informational questions, do not speculate or guess. State what you don't know and what it would take to find out.

## Maintenance
- Keep memory.md compact (<100 lines)
- Aggressively prune stale items
- Done list cleared on Fridays (after weekly summary is generated)
- Every time you create or delete a file, update the _folder_index.md in that folder.
