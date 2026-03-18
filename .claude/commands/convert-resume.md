---
description: Convert a tailored resume Markdown file to DOCX using md-to-docx.py
argument-hint: "[path to .md file in Resume/Tailored/]"
allowed-tools:
  - Bash(python:*)
  - Glob
---

Convert a tailored resume Markdown file to a formatted Word document using `md-to-docx.py`.

## Source Files

- **Script**: `<WORKSPACE_PATH>/Resume/md-to-docx.py`
- **Python**: `<WORKSPACE_PATH>/Resume/.venv/bin/python`
- **Tailored folder**: `<WORKSPACE_PATH>/Resume/Tailored/`

---

## Steps

### Step 1: Get the file path

If a file path argument was provided, use it directly. Resolve relative paths against the project root (`<WORKSPACE_PATH>/`).

If no argument was provided, list the `.md` files in `Resume/Tailored/` and ask Ian which one to convert.

### Step 2: Run the conversion

Run:

```
<WORKSPACE_PATH>/Resume/.venv/bin/python \
  <WORKSPACE_PATH>/Resume/md-to-docx.py \
  "<absolute path to .md file>"
```

### Step 3: Confirm

Tell the user the path to the output `.docx` file.

---

## Notes

- Output is saved in the same folder as the input file, with `.docx` replacing `.md`
- If the script fails, check that `Resume/resume-template.docx` exists
