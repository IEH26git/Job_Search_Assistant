#!/usr/bin/env bash
# extract-transcript.sh — Extract verbatim conversation logs from Claude Code JSONL files by date

set -euo pipefail

PROJECTS_DIR="$HOME/.claude/projects/-Users-<username>-Documents--QON-Tasks"
OUTPUT_DIR="<WORKSPACE_PATH>/TaskMgmt"

usage() {
    echo "Usage: $0 YYYY-MM-DD"
    echo "Example: $0 2026-02-18"
    exit 1
}

if [[ $# -ne 1 ]]; then
    usage
fi

DATE="$1"

# Validate date format
if ! [[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Error: Date must be in YYYY-MM-DD format"
    usage
fi

# Convert YYYY-MM-DD to the format used by ls -la on macOS (e.g., "Feb 18")
YEAR="${DATE%%-*}"
MONTH="${DATE#*-}"; MONTH="${MONTH%%-*}"
DAY="${DATE##*-}"
# Remove leading zero from day for ls comparison
DAY_NO_ZERO="${DAY#0}"

# Convert numeric month to abbreviated name
case "$MONTH" in
    01) MONTH_NAME="Jan" ;;
    02) MONTH_NAME="Feb" ;;
    03) MONTH_NAME="Mar" ;;
    04) MONTH_NAME="Apr" ;;
    05) MONTH_NAME="May" ;;
    06) MONTH_NAME="Jun" ;;
    07) MONTH_NAME="Jul" ;;
    08) MONTH_NAME="Aug" ;;
    09) MONTH_NAME="Sep" ;;
    10) MONTH_NAME="Oct" ;;
    11) MONTH_NAME="Nov" ;;
    12) MONTH_NAME="Dec" ;;
    *) echo "Error: Invalid month '$MONTH'"; exit 1 ;;
esac

# Find JSONL files modified on the given date
# ls -la shows date as "Feb 18" (with space-padded or plain day)
echo "Searching for JSONL files modified on $DATE ($MONTH_NAME $DAY_NO_ZERO)..."

MATCHING_FILES=()

while IFS= read -r line; do
    # Match lines where the date column matches our month/day
    # ls -la format: permissions links owner group size month day time/year filename
    # Date appears as "Feb 18" or "Feb  8" (single-digit days get extra space in some formats)
    if echo "$line" | grep -qE "\.jsonl$"; then
        # Extract the date portion: fields 6 and 7 (month and day)
        file_month=$(echo "$line" | awk '{print $6}')
        file_day=$(echo "$line" | awk '{print $7}')
        file_day_no_zero="${file_day#0}"
        # The year shown if older than ~6 months; time shown if recent — check both cases
        # When year is current, field 8 is HH:MM; we still match on month+day
        if [[ "$file_month" == "$MONTH_NAME" && "$file_day_no_zero" == "$DAY_NO_ZERO" ]]; then
            filename=$(echo "$line" | awk '{print $NF}')
            MATCHING_FILES+=("$filename")
        fi
    fi
done < <(ls -la "$PROJECTS_DIR" 2>/dev/null)

if [[ ${#MATCHING_FILES[@]} -eq 0 ]]; then
    echo "No JSONL files found modified on $DATE in $PROJECTS_DIR"
    exit 0
fi

echo "Found ${#MATCHING_FILES[@]} file(s): ${MATCHING_FILES[*]}"

# Sort files by modification time (oldest first) using ls -lt reversed
SORTED_FILES=()
while IFS= read -r fname; do
    for f in "${MATCHING_FILES[@]}"; do
        if [[ "$f" == "$fname" ]]; then
            SORTED_FILES+=("$fname")
        fi
    done
done < <(ls -lt "$PROJECTS_DIR"/*.jsonl 2>/dev/null | awk '{print $NF}' | xargs -I{} basename {} | tail -r)

# If sorting produced wrong count (xargs/tail -r differences), fall back to original order
if [[ ${#SORTED_FILES[@]} -ne ${#MATCHING_FILES[@]} ]]; then
    SORTED_FILES=("${MATCHING_FILES[@]}")
fi

# Session label helper: 1->a, 2->b, etc.
session_label() {
    local n=$1
    printf "\\$(printf '%03o' $((96 + n)))"
}

CREATED_FILES=()
TOTAL=${#SORTED_FILES[@]}

for i in "${!SORTED_FILES[@]}"; do
    JSONL_FILE="$PROJECTS_DIR/${SORTED_FILES[$i]}"
    SESSION_NUM=$((i + 1))

    # Determine output filename
    if [[ $TOTAL -eq 1 ]]; then
        OUT_FILE="$OUTPUT_DIR/${DATE}-verbatim-conversation-log.md"
        SESSION_LABEL=""
    else
        LABEL=$(session_label $SESSION_NUM)
        OUT_FILE="$OUTPUT_DIR/${DATE}${LABEL}-verbatim-conversation-log.md"
        SESSION_LABEL=" (Session $(echo "$LABEL" | tr '[:lower:]' '[:upper:]'))"
    fi

    JSONL_BASENAME="${SORTED_FILES[$i]}"

    echo "Processing: $JSONL_BASENAME -> $(basename "$OUT_FILE")"

    # Run embedded Python parser via heredoc
    python3 - "$JSONL_FILE" "$DATE" "$JSONL_BASENAME" "$OUT_FILE" << 'PYEOF'
import sys
import json
import re

jsonl_path = sys.argv[1]
date_str = sys.argv[2]
source_name = sys.argv[3]
out_path = sys.argv[4]

SKIP_TAGS = ['<local-command-caveat>', '<command-name>']

def has_skip_tags(text):
    """Return True if the text contains tags that should cause the message to be skipped."""
    for tag in SKIP_TAGS:
        if tag in text:
            return True
    return False

def extract_user_text(record):
    """
    Extract verbatim human text from a user record.
    Returns None if the record should be skipped (tool results, empty, skip tags).
    """
    msg = record.get('message', {})
    if msg.get('role') != 'user':
        return None

    content = msg.get('content', '')

    # content can be a plain string
    if isinstance(content, str):
        text = content.strip()
        if not text:
            return None
        if has_skip_tags(text):
            return None
        return text

    # content is a list of blocks
    if isinstance(content, list):
        # If any block is a tool_result, skip the whole record
        for block in content:
            if isinstance(block, dict) and block.get('type') == 'tool_result':
                return None

        # Collect text blocks
        parts = []
        for block in content:
            if isinstance(block, dict) and block.get('type') == 'text':
                t = block.get('text', '').strip()
                if t:
                    parts.append(t)

        if not parts:
            return None

        full = '\n\n'.join(parts)
        if has_skip_tags(full):
            return None
        return full

    return None

def extract_assistant_text(record):
    """
    Extract verbatim assistant text from an assistant record.
    Returns None if the record should be skipped (tool-only, thinking-only, skip tags).
    Concatenates multiple text blocks.
    """
    msg = record.get('message', {})
    if msg.get('role') != 'assistant':
        return None

    content = msg.get('content', [])
    if not isinstance(content, list):
        return None

    parts = []
    for block in content:
        if not isinstance(block, dict):
            continue
        btype = block.get('type')
        if btype == 'text':
            t = block.get('text', '').strip()
            if t:
                parts.append(t)
        # Skip: thinking, tool_use, tool_result, and any other block types

    if not parts:
        return None

    full = '\n\n'.join(parts)
    if has_skip_tags(full):
        return None
    return full

# Parse the JSONL file and build conversation turns
turns = []  # list of (role, text) tuples

SKIP_TYPES = {'file-history-snapshot', 'queue-operation', 'progress', 'system'}

with open(jsonl_path, 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        try:
            record = json.loads(line)
        except json.JSONDecodeError:
            continue

        rec_type = record.get('type', '')

        if rec_type in SKIP_TYPES:
            continue

        if rec_type == 'user':
            text = extract_user_text(record)
            if text:
                turns.append(('Human', text))

        elif rec_type == 'assistant':
            text = extract_assistant_text(record)
            if text:
                turns.append(('Claude', text))

# Write output
with open(out_path, 'w', encoding='utf-8') as out:
    out.write(f'# {date_str} — Verbatim Conversation Log\n')
    out.write(f'**Source:** {source_name}\n\n')
    out.write('---\n\n')

    if not turns:
        out.write('*No conversation turns found.*\n')
    else:
        for role, text in turns:
            out.write(f'**{role}:** {text}\n\n')
            out.write('---\n\n')

print(f'Wrote {len(turns)} turn(s) to {out_path}')
PYEOF

    CREATED_FILES+=("$OUT_FILE")
done

echo ""
echo "Done. Created ${#CREATED_FILES[@]} file(s):"
for f in "${CREATED_FILES[@]}"; do
    echo "  $f"
done
