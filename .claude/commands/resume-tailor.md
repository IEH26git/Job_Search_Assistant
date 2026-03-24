---
description: Generate a tailored resume from master resume, rules, and a job description
argument-hint: "[path to JD file, or leave blank to paste JD]"
allowed-tools:
  - Read
  - Write
  - Bash(date:*)
---

Tailor Ian's master resume to a specific job description.

## Source Files

- **Master Resume**: `/Users/ianheiman/Desktop/PublicTest/Resume/master-resume.md`
- **Tailoring Rules**: `/Users/ianheiman/Desktop/PublicTest/Resume/resume-rules.md`
- **JDs Folder**: `/Users/ianheiman/Desktop/PublicTest/Resume/JDs/`
- **Output Folder**: `/Users/ianheiman/Desktop/PublicTest/Resume/Tailored/`

## Output Naming Convention

`IEH resume-<MMMyyyy>-<company>-<role>.md`

Example: `IEH resume-Feb2026-Acme-ChiefOfStaff.md`

---

## Steps

### Step 1: Load context

Read both:
1. `Resume/master-resume.md`
2. `Resume/resume-rules.md`

If either file is empty or contains only placeholder comments, stop and tell Ian: "Please populate [filename] before running /resume-tailor."

### Step 2: Get the job description

If a file path argument was provided (e.g., `Resume/JDs/acme-cos.md`), read it.

If no argument was provided, ask Ian:
> "Please paste the job description, or provide the path to the JD file in Resume/JDs/."

Wait for the response before proceeding.

### Step 3: Extract key details for filename

From the job description, identify:
- **Company name** (short form, no spaces — e.g., `Acme`, `PageExec`)
- **Role** (short form, no spaces — e.g., `CoS`, `CSL`, `ProjMgr`)
- **Current month/year** (use today's date)

Construct the output filename:
`IEH resume-<MMMyyyy>-<company>-<role>.md`

### Step 4: Generate the tailored resume

Using the master resume, tailoring rules, and job description:

1. **Analyze** the job description for:
   - Required skills and experience
   - Preferred qualifications
   - Key themes and language used by the employer

2. **Select and adapt** content from the master resume:
   - Prioritize experience most relevant to this role
   - Mirror the employer's language where authentic
   - Apply all rules from `resume-rules.md`

3. **Draft** the tailored resume in Markdown

### Step 5: Save output

Write the tailored resume to:
`/Users/ianheiman/Desktop/PublicTest/Resume/Tailored/<filename>.md`

### Step 6: Confirm

Tell the user:
- The output file path
- 2-3 sentences on the key tailoring decisions made (what was emphasized and why)
- Any gaps between the JD requirements and the master resume content worth noting

---

## Notes

- Do not invent experience — only select and adapt from the master resume
- Keep tailoring decisions transparent so Ian can review and adjust
- If the rules file conflicts with the JD requirements, flag it and ask
- The Profile section text must NOT use a `* ` or `- ` bullet prefix — write it as plain text so `md-to-docx.py` renders it as body text, not a bullet
