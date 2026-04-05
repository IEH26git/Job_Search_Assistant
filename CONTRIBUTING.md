# Adapting This System

This repo is designed to be forked and personalized — not used as-is. The skill files, templates, and workflow are a starting point. Claude can help you reshape any of it to fit your context.

## How to make it your own

**Adapt existing skills to your environment**
> "I use Gmail instead of Apple Mail. Can you rewrite `/process-job-emails` to use the Gmail API?"

> "I'm on Windows. Can you replace the AppleScript in `/collect-links` with something that reads from an `.eml` file?"

**Create new skills**
> "Create a `/weekly-review` command that reads my last 5 daily notes and summarizes what I accomplished and what to carry forward."

> "Add a `/networking-log` command that tracks people I've reached out to and when to follow up."

**Change how existing skills behave**
> "Update `/draft-content` so it always writes in a more casual tone and never uses bullet points."

> "Add a step to `/wrap-up` that asks what I want to focus on tomorrow before closing out."

Every skill is a plain Markdown file in `.claude/commands/`. If you can describe what you want, Claude can write or rewrite it.

## Staying current

This repo is maintained on a best-effort basis. To pull in updates after you've cloned:

```bash
git remote add upstream https://github.com/IEH26git/Job_Search_Assistant
git fetch upstream
git merge upstream/main
```

Note: merging upstream changes may overwrite skill files you've customized. Review the diff before merging and keep a copy of any files you've significantly changed.

## Feedback

If you've built something useful on top of this system and want to share it, feel free to open an issue describing what you made. No guarantees on response time, but it's always interesting to see how people adapt these tools.
