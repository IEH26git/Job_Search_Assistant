#!/usr/bin/env bash
# extract-cursor-transcript.sh — Extract verbatim conversation logs from Cursor agent JSONL files by date

set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "$0")" && pwd)"
CURSOR_PROJECT="$(echo "$WORKSPACE_DIR" | sed 's|/|-|g' | sed 's|^-||')"
TRANSCRIPTS_DIR="$HOME/.cursor/projects/$CURSOR_PROJECT/agent-transcripts"
OUTPUT_DIR="$WORKSPACE_DIR/REF"

usage() {
    echo "Usage: $0 YYYY-MM-DD"
    echo "Example: $0 2026-03-24"
    exit 1
}

if [[ $# -ne 1 ]]; then
    usage
fi

DATE="$1"

if ! [[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Error: Date must be in YYYY-MM-DD format"
    usage
fi

if [[ ! -d "$TRANSCRIPTS_DIR" ]]; then
    echo "Error: Transcript directory not found: $TRANSCRIPTS_DIR"
    exit 1
fi

if [[ ! -d "$OUTPUT_DIR" ]]; then
    echo "Error: Output directory not found: $OUTPUT_DIR"
    exit 1
fi

echo "Searching for Cursor JSONL files modified on $DATE..."

python3 - "$TRANSCRIPTS_DIR" "$OUTPUT_DIR" "$DATE" << 'PYEOF'
import datetime as dt
import json
import os
import pathlib
import string
import sys

transcripts_dir = pathlib.Path(sys.argv[1])
output_dir = pathlib.Path(sys.argv[2])
date_str = sys.argv[3]

try:
    target_date = dt.datetime.strptime(date_str, "%Y-%m-%d").date()
except ValueError:
    print("Error: Date must be in YYYY-MM-DD format")
    sys.exit(1)

jsonl_files = []
for path in transcripts_dir.rglob("*.jsonl"):
    try:
        mtime_date = dt.datetime.fromtimestamp(path.stat().st_mtime).date()
    except OSError:
        continue
    if mtime_date == target_date:
        jsonl_files.append(path)

if not jsonl_files:
    print(f"No JSONL files found modified on {date_str} in {transcripts_dir}")
    print("Try nearby dates:")
    for delta in (-1, 1, -2, 2):
        print(f"  {(target_date + dt.timedelta(days=delta)).isoformat()}")
    sys.exit(0)

jsonl_files.sort(key=lambda p: p.stat().st_mtime)
print(f"Found {len(jsonl_files)} file(s).")

def get_block_texts(content):
    if isinstance(content, str):
        text = content.strip()
        return [text] if text else []
    if not isinstance(content, list):
        return []

    parts = []
    for block in content:
        if not isinstance(block, dict):
            continue
        if block.get("type") == "text":
            text = str(block.get("text", "")).strip()
            if text:
                parts.append(text)
    return parts

def parse_turns(jsonl_path):
    turns = []
    with jsonl_path.open("r", encoding="utf-8") as f:
        for raw in f:
            line = raw.strip()
            if not line:
                continue
            try:
                rec = json.loads(line)
            except json.JSONDecodeError:
                continue

            role = rec.get("role")
            msg = rec.get("message", {})
            content = msg.get("content", [])
            parts = get_block_texts(content)
            if not parts:
                continue

            full = "\n\n".join(parts)
            if role == "user":
                turns.append(("Human", full))
            elif role == "assistant":
                turns.append(("Claude", full))

    return turns

created = []
total = len(jsonl_files)

def session_suffix(i):
    if total == 1:
        return ""
    alphabet = string.ascii_lowercase
    if i < len(alphabet):
        return alphabet[i]
    return f"z{i+1}"

for i, jsonl_path in enumerate(jsonl_files):
    suffix = session_suffix(i)
    if suffix:
        out_name = f"{date_str}{suffix}-cursor-verbatim-conversation-log.md"
    else:
        out_name = f"{date_str}-cursor-verbatim-conversation-log.md"

    out_path = output_dir / out_name
    turns = parse_turns(jsonl_path)

    with out_path.open("w", encoding="utf-8") as out:
        out.write(f"# {date_str} — Cursor Verbatim Conversation Log\n")
        out.write(f"**Source:** {jsonl_path.name}\n\n")
        out.write("---\n\n")
        if not turns:
            out.write("*No conversation turns found.*\n")
        else:
            for role, text in turns:
                out.write(f"**{role}:** {text}\n\n")
                out.write("---\n\n")

    created.append((out_path, len(turns)))

print("")
print(f"Done. Created {len(created)} file(s):")
for path, turns in created:
    print(f"  {path} ({turns} turn(s))")
PYEOF
