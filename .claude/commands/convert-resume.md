---
description: Convert a tailored resume Markdown file to DOCX using md-to-docx.py
argument-hint: "[path to .md file in Resume/Tailored/]"
allowed-tools:
  - Bash(python:*)
  - Glob
---

Convert a tailored resume Markdown file to a formatted Word document using `md-to-docx.py`.

## Source Files

- **Script**: `$PWD/Resume/md-to-docx.py`
- **Python**: `$PWD/Resume/.venv/bin/python`
- **Tailored folder**: `$PWD/Resume/Tailored/`

---

## Steps

### Step 1: Get the file path

If a file path argument was provided, use it directly. Resolve relative paths against the project root (`$PWD/`).

If no argument was provided, list the `.md` files in `Resume/Tailored/` and ask the user which one to convert.

### Step 2: Run the conversion

Run:

```
$PWD/Resume/.venv/bin/python \
  $PWD/Resume/md-to-docx.py \
  "<absolute path to .md file>"
```

### Step 3: Confirm

Tell the user the path to the output `.docx` file.

---

## Notes

- Output is saved in the same folder as the input file, with `.docx` replacing `.md`
- If the script fails, check that `Resume/resume-template.docx` exists
