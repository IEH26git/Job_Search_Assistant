#!/bin/bash
set -euo pipefail

echo ""
echo "=== Personal OS Setup ==="
echo ""
echo "This script configures all skill files to use your workspace path."
echo "Run this once after cloning the repo."
echo ""
read -p "Enter the full path to this folder (e.g. /Users/yourname/Documents/my-personal-os): " WORKSPACE_PATH

# Remove trailing slash if present
WORKSPACE_PATH="${WORKSPACE_PATH%/}"

if [ ! -d "$WORKSPACE_PATH" ]; then
    echo ""
    echo "Error: Directory '$WORKSPACE_PATH' does not exist."
    exit 1
fi

echo ""
echo "Configuring workspace path: $WORKSPACE_PATH"
echo ""

# Find all text files and replace <WORKSPACE_PATH> with the actual path
find "$WORKSPACE_PATH" -type f \( -name "*.md" -o -name "*.sh" -o -name "*.py" -o -name "*.json" \) | while read -r file; do
    if grep -q "<WORKSPACE_PATH>" "$file" 2>/dev/null; then
        sed -i '' "s|<WORKSPACE_PATH>|$WORKSPACE_PATH|g" "$file"
        echo "  Configured: ${file#$WORKSPACE_PATH/}"
    fi
done

echo ""
echo "Setup complete."
echo ""
echo "Next steps:"
echo ""
echo "  1. Install Python dependencies (for /convert-resume):"
echo "     cd \"$WORKSPACE_PATH/Resume\""
echo "     python3 -m venv .venv"
echo "     .venv/bin/pip install python-docx"
echo ""
echo "  2. Customize your role criteria and templates:"
echo "     - Templates/Role_Search_Criteria.md"
echo "     - Templates/job-search-priorities.md"
echo "     - Resume/master-resume.md"
echo "     - .claude/memory.md"
echo ""
echo "  3. Open Claude Code:"
echo "     cd \"$WORKSPACE_PATH\" && claude"
echo ""
echo "  4. Run /start to begin."
echo ""
