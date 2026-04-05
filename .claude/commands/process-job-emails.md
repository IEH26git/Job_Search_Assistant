---
description: Process selected job emails from Apple Mail — fetch postings, evaluate against criteria, create JD files, and update Task Board
argument-hint: "[delete] — omit to run in test mode (no deletions); pass 'delete' to execute queued deletions"
allowed-tools:
  - Read
  - Write
  - Edit
  - WebFetch
  - Bash(date:*)
  - Bash(osascript:*)
---

Process job emails selected in Apple Mail. In test mode (default), fetches postings, evaluates them against role criteria, creates JD files, and saves a deletion queue — without touching any emails. In delete mode, reads the queue and deletes those specific emails from Mail.

## Key File Paths

- **Role Criteria**: `/Users/ianheiman/Desktop/PublicTest/Templates/Role_Search_Criteria.md`
- **JDs Folder**: `/Users/ianheiman/Desktop/PublicTest/Resume/JDs/`
- **Task Board**: `/Users/ianheiman/Desktop/PublicTest/Task Board.md`
- **Email Queue**: `/Users/ianheiman/Desktop/PublicTest/.claude/email_queue.md`

---

## Mode Detection

Check the argument passed to this command.

- If the argument is `delete` (case-insensitive), skip to **Delete Mode** (Steps 7–9).
- Otherwise, run **Test Mode** (Steps 1–6).

---

## TEST MODE (default)

### Step 1: Read role criteria

Read `/Users/ianheiman/Desktop/PublicTest/Templates/Role_Search_Criteria.md`.

If the file does not exist or contains only placeholder content, stop and tell the user:
> "Please populate `Templates/Role_Search_Criteria.md` before running /process-job-emails."

Hold this criteria in memory for use in Step 5.

### Step 2: Get today's date and time

Run `date` and format the result as `YYYY-MM-DD HH:MM`. Store for use in file headers and Task Board entries.

### Step 3: Retrieve selected emails from Apple Mail

Run the following AppleScript via `osascript`:

```applescript
tell application "Mail"
    set selectedMessages to selection
    set output to ""
    repeat with msg in selectedMessages
        set output to output & "---MESSAGE_START---" & return
        set output to output & "Subject: " & subject of msg & return
        set output to output & "From: " & sender of msg & return
        set output to output & "Date: " & (date received of msg as string) & return
        set output to output & "---BODY_START---" & return
        set output to output & content of msg & return
        set output to output & "---MESSAGE_END---" & return
    end repeat
    return output
end tell
```

Parse the output into a list of messages. Each message has:
- `Subject` — text on the "Subject:" line
- `From` — text on the "From:" line
- `Date` — text on the "Date:" line
- `Body` — everything between `---BODY_START---` and `---MESSAGE_END---`

If the result is empty (no messages selected or Mail is not running), stop and tell the user:
> "No emails are selected in Apple Mail. Please select one or more emails in your Exchange Inbox and run this command again. Make sure Mail is open and use Cmd+Tab to switch to Claude Code without clicking away from your selection."

Otherwise, tell the user: "Found N selected email(s). Processing..."

### Step 4: Extract URLs and fetch job postings

For each email, work through these sub-steps:

**4a. Extract all URLs** from the email body. Look for:
- Bare URLs starting with `http://` or `https://`
- Markdown-style links: `[text](URL)`

**4b. Identify the most likely job posting URL.** Prefer URLs whose domain or path contains any of: `/jobs/`, `/careers/`, `/job/`, `/posting/`, `/position/`, `/opening/`, `greenhouse.io`, `lever.co`, `workday.com`, `linkedin.com/jobs`, `ashbyhq.com`, `jobvite.com`, `icims.com`, `smartrecruiters.com`, `taleo.net`. Avoid unsubscribe links, tracking pixels, company homepages, and legal/footer URLs.

**4c. If no posting URL can be identified**, mark the email as "no URL found", note it in your running log, and move to the next email without failing the run.

**4d. Fetch the posting URL** using WebFetch with the prompt: "Extract the full job title, company name, location, job description, responsibilities, qualifications, salary range if listed, and any other relevant details. Return all text content from the job posting."

**4e. Handle fetch failures gracefully:**
- If the page requires a login (LinkedIn, some Workday instances): mark as "fetch failed — login required"
- If the page appears to be JavaScript-rendered with no job text: mark as "fetch failed — JS-rendered page"
- If any other error: mark as "fetch failed — [reason]"
- In all failure cases, note it and move to the next email without stopping the run.

### Step 5: Evaluate each fetched posting against criteria

For each successfully fetched posting, apply the following evaluation using the criteria loaded in Step 1:

**5a. Check exclusion criteria first.** If any exclusion rule matches (excluded company name, excluded role type, unacceptable location, exclusion phrase found verbatim), mark as **Not a Fit** immediately. Record the reason and skip steps 5b–5e for this posting.

**5b. Check seniority.** Compare the role's apparent level against the target seniority range in the criteria. If clearly below the minimum or above the maximum, mark as **Not a Fit**.

**5c. Count required keywords.** Scan the posting text for all required keywords listed in the criteria. Count how many are present.

**5d. Check domain/industry match.** Does the role or company fall within the preferred domains and industries?

**5e. Assign a fit score** using this rubric:

- **Strong Fit**: Seniority matches target range + 3 or more required keywords present + domain matches at least one target domain + no exclusions triggered
- **Possible Fit**: Seniority close but not perfect (e.g., Senior Manager at a large firm), OR 1–2 required keywords present, OR partial domain match — but no exclusions triggered
- **Not a Fit**: Exclusion triggered, OR zero required keywords, OR seniority clearly below minimum, OR location unacceptable, OR fetch failed with no content to evaluate

Record for each posting: company name, role title, posting URL, fit score, and a one-sentence rationale.

### Step 6: Create JD files, save queue, and update Task Board

**6a. Create JD files** for Strong Fit and Possible Fit postings only. Skip Not a Fit postings.

For each qualifying posting:

1. Construct the filename: `JD-<Company>-<Role>.md`
   - Use short forms without spaces (e.g., `JD-Acme-VPofAI.md`, `JD-CapOne-DirGenAI.md`)
   - If a file with that exact name already exists in `Resume/JDs/`, append the date: `JD-Acme-VPofAI-2026-02-25.md`

2. Write the file to `/Users/ianheiman/Desktop/PublicTest/Resume/JDs/<filename>` with this format:

```
--- Captured: YYYY-MM-DD HH:MM | Fit: [Strong Fit / Possible Fit] ---
[Source](URL)

[Full job description text as fetched — preserve all sections, headings, and bullet points]
```

**6b. Create Manual Review file** if any notable roles were identified during digest pre-screening (Step 4c) or if any fetch attempts failed but the role seemed promising.

A role is "notable" if it meets at least two of:
- Title matches or is adjacent to a Target Role Title
- Seniority appears to be at or above Director level
- Company or domain is relevant to Target Domains

For each notable role, capture:
- **Company** and **Role Title** (from digest text)
- **Location** (from digest text)
- **Salary** (if shown in digest)
- **Source** (e.g., LinkedIn, Lensa)
- **URL**: Use the job posting URL if one was found but failed to fetch. Otherwise write *(not available)*.
- **Find it**: If no URL is available, write: `Search [source] for "[Company] — [Role Title]"`

**Output format depends on the number of notable roles:**

- **8 or more notable roles** → create a CSV file: `Manual-Review-YYYY-MM-DD.csv`
- **7 or fewer notable roles** → create a Markdown file: `Manual-Review-YYYY-MM-DD.md`

**CSV format** (use when 8+ roles):

Write the file to `/Users/ianheiman/Desktop/PublicTest/Resume/JDs/Manual-Review-YYYY-MM-DD.csv` with these columns:

```
Employer,Job Title,Location,Salary,Source,URL,Find It
```

One row per role. Quote any field that contains a comma. For fields containing double quotes, escape them by doubling (`""`).

**Markdown format** (use when 7 or fewer roles):

Write the file to `/Users/ianheiman/Desktop/PublicTest/Resume/JDs/Manual-Review-YYYY-MM-DD.md` using this format:

```markdown
# Manual Review — YYYY-MM-DD

Roles flagged from email digests for manual lookup. Review each and decide to pursue (create a JD file) or pass.

---

## [Company] — [Role Title]

- **Location**: [location]
- **Salary**: [salary range, or *not listed*]
- **Source**: [LinkedIn / Lensa / JobLeads / etc.]
- **URL**: [URL, or *(not available)*]
- **Find it**: Search [source] for "[Company] — [Role Title]"
- **Decision**:

---
```

If no notable roles were identified, skip this step silently — do not create an empty file.

If a Manual Review file already exists for today's date (`.md` or `.csv`), append new entries to it rather than overwriting. Match the existing file's format regardless of the count rule.

**6c. Save the email queue.** Write (or overwrite) `/Users/ianheiman/Desktop/PublicTest/.claude/email_queue.md` with one row per processed email — all emails from this run, not just those that created JD files.

Format the `Date Received` column as `YYYY-MM-DD` (extract from the AppleScript date string — e.g., "Wednesday, February 25, 2026 at 1:26:53 PM" → `2026-02-25`). This format is used by the delete step to filter by year, month, and day.

```markdown
# Email Queue — YYYY-MM-DD

Emails processed in test mode. Run `/process-job-emails delete` to delete these from Mail.

## Queue

| Subject | From | Date Received |
| :--- | :--- | :--- |
| [subject] | [sender] | YYYY-MM-DD |
```

This queue will be overwritten on the next test-mode run. Run delete mode before processing a new batch if you want both batches deleted.

**6d. Update the Task Board.** Read `/Users/ianheiman/Desktop/PublicTest/Task Board.md` and append one line to the **Inbox** section:

```
- [YYYY-MM-DD] Processed N email(s): created M JD(s) — JD-X.md, JD-Y.md. Best fit(s): JD-X.md. [Z roles flagged for manual review → Manual-Review-YYYY-MM-DD.md] [W skipped: reason summary]
```

Rules:
- List "Best fit(s)" only if any Strong Fit postings exist; omit the clause if none.
- If zero JDs were created, say "0 JDs created" and omit the filename list.
- If a Manual Review file was created, include "N roles flagged for manual review → Manual-Review-YYYY-MM-DD.[md|csv]" (use whichever extension was created); omit if no file was created.
- Summarize skipped emails briefly (e.g., "2 skipped: fetch failed").
- Append inside the Inbox section without disturbing any other content.

**6e. Report to the user.** Tell the user:
- Total emails processed
- For each email: subject, company/role extracted (or skip reason), fit score, and JD filename if created
- Total JDs created and their filenames
- Which posting(s) scored Strong Fit
- If a Manual Review file was created: its filename and the roles it contains
- Confirmation that the queue was saved to `.claude/email_queue.md`
- Reminder: "Run `/process-job-emails delete` when you're ready to remove these emails from your Exchange Inbox."

---

## DELETE MODE

### Step 7: Read the email queue

Read `/Users/ianheiman/Desktop/PublicTest/.claude/email_queue.md`.

If the file does not exist, is empty, or the queue table contains no data rows, stop and tell the user:
> "No email queue found. Run `/process-job-emails` first to process a batch of emails and build the deletion queue."

Parse the queue table to get a list of `{subject, sender, date}` triples. The `Date Received` column is in `YYYY-MM-DD` format — parse it into numeric year, month (as AppleScript month constant, e.g., `February`), and day for use in the deletion filter. Tell the user: "Found N email(s) in queue. Proceeding with deletion..."

### Step 8: Delete each queued email from Apple Mail

For each `{subject, sender, date}` row in the queue, construct and run an AppleScript via `osascript` that searches only `mailbox "Inbox" of account "Exchange"`.

Use `contains` for subject matching (not `is`) to avoid smart/curly quote mismatches between stored subjects and actual email subjects. Also filter by the date received (year, month, day) to avoid accidentally matching older emails with identical subject lines.

```applescript
tell application "Mail"
    set targetSubjectFragment to "DISTINCTIVE_SUBJECT_FRAGMENT_HERE"
    set targetSender to "SENDER_HERE"
    set targetYear to YEAR_HERE
    set targetMonth to MONTH_HERE
    set targetDay to DAY_HERE
    set deletedCount to 0
    set mb to mailbox "Inbox" of account "Exchange"
    set msgs to messages of mb
    repeat with msg in msgs
        set msgDate to date received of msg
        if (year of msgDate is targetYear) and (month of msgDate is targetMonth) and (day of msgDate is targetDay) then
            if (subject of msg contains targetSubjectFragment) and (sender of msg is targetSender) then
                delete msg
                set deletedCount to deletedCount + 1
            end if
        end if
    end repeat
    return deletedCount
end tell
```

Choose `targetSubjectFragment` as a unique substring of the subject that avoids any leading smart-quote characters (e.g., use the company/role portion rather than the leading quoted keyword).

Record whether each message was found and deleted (count > 0) or not found (count = 0).

### Step 9: Clear the queue and report

**9a.** Overwrite `/Users/ianheiman/Desktop/PublicTest/.claude/email_queue.md` with:

```markdown
# Email Queue

_Empty — last cleared: YYYY-MM-DD_
```

**9b.** Report to the user:
- Total emails targeted for deletion
- How many were found and deleted (moved to Deleted Items in Exchange)
- How many were not found (already deleted, moved, or subject/sender mismatch)
- Confirmation that the queue file is cleared

---

## Notes

- **Heredoc syntax**: When constructing `osascript` Bash calls, always use `<<EOF` (unquoted), NOT `<<'EOF'`. The single-quoted form triggers a Claude Code security warning ("quoted characters in flag names") that prompts the user for confirmation. Since the AppleScript contains no shell variables, unquoted EOF is safe and avoids the interruption.
- **Mail must be open** for AppleScript to work. If osascript returns an error about Mail not running, tell the user to open Mail and try again.
- **Deletion moves to Deleted Items**, not permanent erasure. The user can review the Exchange `Deleted Items` folder before emptying it.
- **Subject matching is exact.** If an email subject has been modified (e.g., a mail rule prepended text), it will not match the stored subject. The queue stores subjects as read by AppleScript at processing time, so consistency is maintained within a single batch.
- **LinkedIn job URLs** typically require authentication and will return a login wall when fetched. Note these as "fetch failed — login required" and skip. The user can save LinkedIn postings manually using the existing JD file format.
- **Queue overwrite**: Processing a new batch overwrites the queue. Run delete mode between batches to ensure all emails get cleaned up.
