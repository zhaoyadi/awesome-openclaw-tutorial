#!/usr/bin/env bash
# Convert all markdown files into a single DOCX document

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOCS_DIR="$PROJECT_ROOT/docs"
OUTPUT_DIR="$PROJECT_ROOT/output"
OUTPUT_FILE="$OUTPUT_DIR/awesome-openclaw-tutorial.docx"

# Check pandoc
if ! command -v pandoc &> /dev/null; then
    echo -e "${RED}Error: pandoc is not installed${NC}"
    echo "Install it with: brew install pandoc"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo -e "${GREEN}Creating single DOCX document (all chapters)...${NC}"
echo ""

# Create temporary file list
TEMP_LIST=$(mktemp)

# Collect only numbered chapter files (01-*.md, 02-*.md, etc.)
# Exclude CHAPTER-*, SPLIT-*, PLAN-*, PROGRESS-*, DIRECTORY-* files
find "$DOCS_DIR" -type f -name "[0-9][0-9]-*.md" ! -path "*/images/*" | \
  grep -v "CHAPTER-" | \
  grep -v "SPLIT-" | \
  grep -v "PLAN-" | \
  grep -v "PROGRESS-" | \
  grep -v "DIRECTORY-" | \
  sort > "$TEMP_LIST"

# Show files to be merged
echo -e "${YELLOW}Files to merge:${NC}"
cat "$TEMP_LIST" | while read -r file; do
    echo "  - ${file#$DOCS_DIR/}"
done
echo ""

# Convert to single DOCX
echo -e "${YELLOW}Converting to DOCX...${NC}"
if pandoc $(cat "$TEMP_LIST") \
    --from markdown \
    --to docx \
    --output "$OUTPUT_FILE" \
    --standalone \
    --toc \
    --toc-depth=3 \
    --highlight-style=tango \
    --metadata title="Awesome OpenClaw Tutorial" \
    2>/dev/null; then
    echo -e "${GREEN}✓ Success!${NC}"
    echo "Output: $OUTPUT_FILE"
    echo ""
    echo "To open the document:"
    echo "  open '$OUTPUT_FILE'"
else
    echo -e "${RED}✗ Conversion failed${NC}"
    rm -f "$TEMP_LIST"
    exit 1
fi

# Cleanup
rm -f "$TEMP_LIST"
