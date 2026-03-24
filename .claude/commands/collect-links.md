---
description: Extract links from selected Apple Mail emails and append them to REF/Links.md with metadata
argument-hint: "[delete] — omit to run in test mode (no deletions); pass 'delete' to execute queued deletions"
allowed-tools:
  - Read
  - Write
  - Edit
  - WebFetch
  - Bash(date:*)
  - Bash(osascript:*)
---

Extract links from emails selected in Apple Mail, fetch page titles and descriptions, and append each link to `REF/Links.md` — skipping any URLs already in the file. Supports a delete mode to clean up processed emails from your inbox.

## Key File Paths

- **Links File**: `/Users/ianheiman/Desktop/PublicTest/REF/Links.md`
- **Email Queue**: `/Users/ianheiman/Desktop/PublicTest/.claude/links_email_queue.md`

---

## Mode Detection

Check the argument passed to this command.

- If the argument is `delete` (case-insensitive), skip to **Delete Mode** (Steps 8–10).
- Otherwise, run **Collect Mode** (Steps 1–7).

---

## COLLECT MODE (default)

### Step 1: Get today's date

Run `date` and format as `YYYY-MM-DD`. Store for use in entries.

---

### Step 2: Retrieve selected emails from Apple Mail

Run the following AppleScript via `osascript`:

```applescript
tell application "Mail"
    set selectedMessages to selection
    set output to ""
    repeat with msg in selectedMessages
        set mbName to name of (mailbox of msg)
        if mbName is "Inbox" then
            set output to output & "---MESSAGE_START---" & return
            set output to output & "Subject: " & subject of msg & return
            set output to output & "From: " & sender of msg & return
            set output to output & "Date: " & (date received of msg as string) & return
            set output to output & "---BODY_START---" & return
            set output to output & content of msg & return
            set output to output & "---MESSAGE_END---" & return
        end if
    end repeat
    return output
end tell
```

Parse the output into a list of messages. Each message has:
- `Subject` — text on the "Subject:" line
- `From` — text on the "From:" line
- `Date` — text on the "Date:" line
- `Body` — everything between `---BODY_START---` and `---MESSAGE_END---`

If the result is empty, stop and tell Ian:
> "No emails are selected in Apple Mail. Please select one or more emails **from your Inbox** and run this command again. Only Inbox emails are processed — Sent items are skipped. Make sure Mail is open and use Cmd+Tab to switch back to Claude Code without clicking away from your selection."

Otherwise, tell Ian: "Found N selected email(s). Processing..."

---

### Step 3: Extract all URLs

For each email, extract all unique URLs from the body. Look for:
- Bare URLs starting with `http://` or `https://`
- Markdown-style links: `[text](URL)`

Deduplicate within the email. Discard obvious junk URLs: unsubscribe links, tracking pixels, email footers, and URLs whose path contains any of: `unsubscribe`, `optout`, `opt-out`, `track`, `click?`, `beacon`, `pixel`.

If an email yields no usable URLs after filtering, note it and move on.

---

### Step 4: Load existing links file and deduplicate

Read `/Users/ianheiman/Desktop/PublicTest/REF/Links.md` if it exists.

Extract all URLs already present in the file. Any URL found in the existing file should be **skipped silently** — do not add it again, do not mention it in the report.

If the file does not exist, proceed — you will create it in Step 6.

---

### Step 5: Fetch each new URL

For each URL not already in the file:

**5a. Fetch the page** using WebFetch with the prompt:
> "Return the page title and a one-sentence summary of the page's main topic or purpose."

**5b. Handle fetch results:**
- **Success**: Store the page title and one-sentence description.
- **Any failure** (login wall, JS-rendered, network error, paywall): Store the URL with no title or description — it will be added as a bare URL entry.

Do not stop the run for any individual fetch failure.

---

### Step 6: Append new entries to Links.md

Read the current contents of `/Users/ianheiman/Desktop/PublicTest/REF/Links.md` (or start with an empty file if it doesn't exist).

For each new URL, append one entry in this format:

**If fetch succeeded:**
```markdown
- **[Page Title](URL)**
  - Added: YYYY-MM-DD | From: [email subject]
  - > [One-sentence description]
```

**If fetch failed:**
```markdown
- **[URL](URL)**
  - Added: YYYY-MM-DD | From: [email subject]
```

Append all new entries at the **bottom** of the file.

If the file does not exist yet, create it with this header first:
```markdown
# Links

A running list of links collected from email.

---

```

Then append the entries.

If there are no new entries to add (all URLs were duplicates or all emails had no usable URLs), tell Ian and stop — do not write anything.

---

### Step 7: Save the email queue and report

**7a. Save the email queue.** Write (or overwrite) `/Users/ianheiman/Desktop/PublicTest/.claude/links_email_queue.md` with one row per processed email — all emails from this run.

Format the `Date Received` column as `YYYY-MM-DD` (extract from the AppleScript date string — e.g., "Wednesday, March 9, 2026 at 1:26:53 PM" → `2026-03-09`).

```markdown
# Links Email Queue — YYYY-MM-DD

Emails processed in collect mode. Run `/collect-links delete` to delete these from Mail.

## Queue

| Subject | From | Date Received |
| :--- | :--- | :--- |
| [subject] | [sender] | YYYY-MM-DD |
```

This queue will be overwritten on the next collect-mode run. Run delete mode before processing a new batch if you want both batches deleted.

**7b. Report to Ian.** Tell the user:
- Total emails processed
- Total new links added
- For each new link: the page title (or bare URL) and which email it came from
- How many URLs were skipped as duplicates (total count only — no details)
- How many fetch failures resulted in bare URL entries
- Reminder: "Run `/collect-links delete` when you're ready to remove these emails from your Exchange Inbox."

---

## DELETE MODE

### Step 8: Read the email queue

Read `/Users/ianheiman/Desktop/PublicTest/.claude/links_email_queue.md`.

If the file does not exist, is empty, or the queue table contains no data rows, stop and tell Ian:
> "No email queue found. Run `/collect-links` first to process a batch of emails and build the deletion queue."

Parse the queue table to get a list of `{subject, sender, date}` triples. The `Date Received` column is in `YYYY-MM-DD` format — parse it into numeric year, month (as AppleScript month constant, e.g., `March`), and day for use in the deletion filter. Tell the user: "Found N email(s) in queue. Proceeding with deletion..."

---

### Step 9: Delete each queued email from Apple Mail

For each `{subject, sender, date}` row in the queue, construct and run an AppleScript via `osascript` that searches only `mailbox "Inbox" of account "Exchange"`.

Use `contains` for subject matching (not `is`) to avoid smart/curly quote mismatches. Also filter by date received (year, month, day) to avoid accidentally matching older emails with identical subject lines.

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

Choose `targetSubjectFragment` as a unique substring of the subject that avoids any leading smart-quote characters.

Record whether each message was found and deleted (count > 0) or not found (count = 0).

---

### Step 10: Clear the queue and report

**10a.** Overwrite `/Users/ianheiman/Desktop/PublicTest/.claude/links_email_queue.md` with:

```markdown
# Links Email Queue

_Empty — last cleared: YYYY-MM-DD_
```

**10b.** Report to Ian:
- Total emails targeted for deletion
- How many were found and deleted (moved to Deleted Items in Exchange)
- How many were not found (already deleted, moved, or subject/sender mismatch)
- Confirmation that the queue file is cleared

---

## Notes

- **Mail must be open** for AppleScript to work. If osascript returns an error about Mail not running, tell Ian to open Mail and try again.
- **Deletion moves to Deleted Items**, not permanent erasure. Ian can review the Exchange `Deleted Items` folder before emptying it.
- **Queue overwrite**: Processing a new batch overwrites the queue. Run delete mode between batches to ensure all emails get cleaned up.
