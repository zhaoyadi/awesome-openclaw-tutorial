#!/usr/bin/env bash
# Markdown to DOCX converter script
# Converts all markdown files in docs/ to DOCX format

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOCS_DIR="$PROJECT_ROOT/docs"
OUTPUT_DIR="$PROJECT_ROOT/output/docx"

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo -e "${RED}Error: pandoc is not installed${NC}"
    echo "Install it with: brew install pandoc"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo -e "${GREEN}Starting Markdown to DOCX conversion (from Chapter 6)...${NC}"
echo "Source: $DOCS_DIR"
echo "Output: $OUTPUT_DIR"
echo ""

# Counter for converted files
converted=0
failed=0

# Find and convert markdown files starting from chapter 6
while IFS= read -r -d '' md_file; do
    # Get relative path from docs directory
    rel_path="${md_file#$DOCS_DIR/}"
    
    # Skip images directory
    if [[ "$rel_path" == images/* ]]; then
        continue
    fi
    
    # Skip files before chapter 6 (02-core-features/06-*)
    if [[ "$rel_path" == 01-basics/* ]]; then
        continue
    fi
    if [[ "$rel_path" == 02-core-features/0[1-5]-* ]]; then
        continue
    fi
    
    # Create output filename (preserve directory structure)
    output_file="$OUTPUT_DIR/${rel_path%.md}.docx"
    output_dir="$(dirname "$output_file")"
    
    # Create output subdirectory if needed
    mkdir -p "$output_dir"
    
    echo -e "${YELLOW}Converting:${NC} $rel_path"
    
    # Convert with pandoc
    if pandoc "$md_file" \
        --from markdown \
        --to docx \
        --output "$output_file" \
        --standalone \
        --toc \
        --toc-depth=3 \
        --highlight-style=tango \
        2>/dev/null; then
        echo -e "${GREEN}✓ Success:${NC} ${output_file#$PROJECT_ROOT/}"
        ((converted++))
    else
        echo -e "${RED}✗ Failed:${NC} $rel_path"
        ((failed++))
    fi
    echo ""
done < <(find "$DOCS_DIR" -type f -name "*.md" -print0 | sort -z)

# Summary
echo "================================"
echo -e "${GREEN}Conversion complete!${NC}"
echo "Converted: $converted files"
if [ $failed -gt 0 ]; then
    echo -e "${RED}Failed: $failed files${NC}"
fi
echo "Output directory: $OUTPUT_DIR"
echo ""
echo "To view all converted files:"
echo "  open $OUTPUT_DIR"
