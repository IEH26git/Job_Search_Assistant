---
name: adapt-skill
description: Adapts a skill file from another Claude project to work for a target agent, then deletes the source file
argument-hint: "[path to source skill file]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash(find:*)
  - Bash(rm:*)
  - Bash(ls:*)

---

Adapt the skill file provided by the user to work for a target agent. Follow these steps exactly.

## Step 1 — Identify the source file

The user will either:
- Pass a file path as an argument to this command, or
- Have dropped a `.md` file somewhere in the current project directory.

If no path was given as an argument, run `find . -name "*.md" -newer .claude/commands/adapt-skill.md -not -path "*/.claude/*" -not -path "*/.git/*"` to locate recently added `.md` files and ask the user to confirm which one is the source skill.

Read the source file completely before doing anything else.

## Step 2 — Identify the target agent

Ask the user:
> "Which agent should this skill be adapted for?
> 1. This agent
> 2. Other (provide the agent's working directory path and nickname)"

Wait for the response before proceeding.

- If the user selects **1**, run `pwd` to get the current working directory and use it as `TARGET_DIR`. Extract the final path component as `TARGET_NAME`.
- If the user selects **2**, use the path they provide as `TARGET_DIR` and the nickname they provide as `TARGET_NAME`.

## Step 3 — Analyze the skill

Identify:
- What the skill does (its purpose and steps)
- Any project-specific references that need changing: agent name, directory paths, memory layer references, tool names, scope assumptions, output locations, or other project identifiers
- Whether the skill's purpose is in scope for the target agent. If it is clearly out of scope, tell the user and stop.

## Step 4 — Adapt the skill

Produce a modified version of the skill with these changes applied:

**Identity and paths:**
- Replace any other agent name or nickname with `TARGET_NAME`
- Update all directory paths to reflect `TARGET_DIR` as the project root
- Update output folder references to match the target agent's folder structure (read from the target's CLAUDE.md if available at `TARGET_DIR/CLAUDE.md`)

**Memory layer references** (standard across all agents — update if the source uses different names):
- Active session context → `.claude/memory.md`
- Structured local facts → `claude-local-memory.db` (SQLite)
- Cross-tool thought captures → Open Brain MCP (`mcp__open-brain__capture_thought`, etc.)
- Persistent preferences/profile → auto-memory at `~/.claude/projects/.../memory/`

**Prose and formatting rules (apply to any output the skill generates):**
- No sentence fragments
- No em-dashes connecting two independent clauses
- No parallelisms ("it's not X, it's Y") — use direct assertions
- Tables: left-justify all cells except number/currency columns (right-justify those); header alignment matches column data alignment

**Frontmatter:**
- Ensure the `name:` field matches the destination filename (without `.md`)
- Keep or write a clear one-line `description:`
- Add or preserve `allowed-tools:` listing all tools the skill uses

**Scope guard:**
- If the original skill had a scope check for a different domain, update it to match the target agent's scope.

Do not add features or steps that weren't in the original. Do not remove steps unless they are entirely inapplicable and have no equivalent in the target agent.

## Step 5 — Write the adapted skill

Save the adapted skill to `TARGET_DIR/.claude/commands/<name>.md` where `<name>` matches the `name:` frontmatter field. Create the directory if it doesn't exist.

If a file already exists at that path, show the user the diff and ask whether to overwrite before writing.

## Step 6 — Confirm and delete the source file

Show the user:
1. The path where the adapted skill was saved
2. A brief plain-English summary of what was changed

Then delete the source file. Do not ask for confirmation before deleting — the user requested this behavior when they invoked this skill.

After deleting, confirm: "Source file deleted: `<path>`."
