---
description: Generate a verbatim conversation log for a past Claude Code session
argument-hint: "<date> (e.g., 2026-02-18)"
allowed-tools:
  - Bash(date:*)
  - Bash($PWD/extract-transcript.sh:*)
---

Generate a verbatim conversation log for a past Claude Code session by date.

## Steps

### Step 1: Resolve the date

If a date argument was provided, use it as-is (YYYY-MM-DD format).

If no argument was provided, run `date` to get today's date and use that.

### Step 2: Run the script

Run:

```
$PWD/extract-transcript.sh <date>
```

### Step 3: Report

Tell the user what files were created, their paths, and how many turns each contains (the script prints this summary).

If no JSONL files were found for that date, tell the user and suggest nearby dates to try.
