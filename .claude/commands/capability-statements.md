---
description: Transform a job description into first-person capability statements, grouped by section
argument-hint: "[path to JD file, or leave blank to select]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Bash(date:*)
---

Generate first-person capability statements from a job description, reusing as much verbatim language as possible. Output is saved alongside the original JD file.

## Source Files

- **JDs Folder**: `/Users/ianheiman/Desktop/PublicTest/Resume/JDs/`
- **Output**: Same folder as the input JD, with `-capabilities` appended to the filename

## Output Naming Convention

Same filename as the input JD, with `-capabilities` before the `.md` extension.

Example: `JD-CapOne-BusDir-GenAI Mgmt Strategy.md` → `JD-CapOne-BusDir-GenAI Mgmt Strategy-capabilities.md`

---

## Steps

### Step 1: Get the job description file

If a file path argument was provided, read it directly.

If no argument was provided, list the files in `Resume/JDs/` and ask the user:
> "Which JD would you like to process? (Provide the filename or number)"

Wait for the response before proceeding.

### Step 2: Read the JD file

Read the full content of the JD file.

### Step 3: Parse by section

Identify all section headings in the JD (e.g., Responsibilities, Requirements, Qualifications, Preferred Qualifications, Nice to Have, About the Role, What You'll Do, What We're Looking For, etc.).

For each section, collect all bullet points and numbered items.

### Step 4: Transform each item into a capability statement

For each bullet/item, restate it as a first-person assertion. **Preserve the original wording as closely as possible** — only add the minimal framing needed.

Follow these patterns:

| JD phrasing pattern | Transform to |
|---|---|
| Noun/gerund phrase ("Comfort with ambiguity...", "Experience leading...") | "I have [noun/phrase]..." or "I am [adjective]..." |
| Verb phrase ("Partner with stakeholders...", "Lead cross-functional teams...") | "I [verb phrase]..." or "I have experience [verb+ing]..." |
| Adjective phrase ("Comfortable operating with...", "Proven ability to...") | "I am [adjective phrase]..." |
| Credential or threshold ("Bachelor's degree in...", "5+ years of...") | "I hold [credential]..." or "I have [X years]..." |

**Key principle:** Reuse the JD's exact words. Do not paraphrase, embellish, or invent. The goal is a verbatim restatement with a first-person frame.

**Edge cases:**
- If a bullet is a section header restated as text, skip it unless it forms a meaningful standalone statement
- If a bullet contains multiple distinct qualifications, it's acceptable to keep it as one compound statement

### Step 5: Compose the output file

Structure the output as:

```
# Capability Statements — [Role Title] at [Company]

Source: [original JD filename]
Generated: [today's date]

---

## [Section Name from JD]

- [Capability statement]
- [Capability statement]
...

## [Next Section Name]

- [Capability statement]
...
```

### Step 6: Save output

Construct the output filename by inserting `-capabilities` before `.md` in the input filename.

Write the file to the same directory as the input JD:
`/Users/ianheiman/Desktop/PublicTest/Resume/JDs/<original-name>-capabilities.md`

### Step 7: Confirm

Tell the user:
- The output file path
- Total number of capability statements generated
- Any bullets that were skipped and why

---

## Notes

- Do not invent or embellish — restate only what the JD says
- Preserve verbatim language; the value is in mirroring the employer's words
- These statements are a content palette — the user will select and adapt them for resumes and cover letters, not use them as-is
