#!/usr/bin/env bash
# 将每个章节单独转换为DOCX文件

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOCS_DIR="$PROJECT_ROOT/docs"
OUTPUT_DIR="$PROJECT_ROOT/output/chapters"

# Check pandoc
if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is not installed"
    echo "Install it with: brew install pandoc"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo -e "${GREEN}将19个章节分别转换为DOCX...${NC}"
echo ""

# Get all chapter files
CHAPTERS=(
  "$DOCS_DIR/01-basics/01-introduction.md"
  "$DOCS_DIR/01-basics/02-installation.md"
  "$DOCS_DIR/01-basics/03-advanced-deployment.md"
  "$DOCS_DIR/01-basics/04-maintenance-upgrade.md"
  "$DOCS_DIR/01-basics/05-quick-start.md"
  "$DOCS_DIR/02-core-features/06-file-management.md"
  "$DOCS_DIR/02-core-features/07-knowledge-management.md"
  "$DOCS_DIR/02-core-features/08-schedule-management.md"
  "$DOCS_DIR/02-core-features/09-automation-workflow.md"
  "$DOCS_DIR/03-advanced/10-skills-extension.md"
  "$DOCS_DIR/03-advanced/11-multi-platform-integration.md"
  "$DOCS_DIR/03-advanced/12-feishu-bot.md"
  "$DOCS_DIR/03-advanced/13-wework-dingtalk-qq.md"
  "$DOCS_DIR/03-advanced/14-api-integration.md"
  "$DOCS_DIR/03-advanced/15-advanced-configuration.md"
  "$DOCS_DIR/04-practical-cases/16-personal-productivity.md"
  "$DOCS_DIR/04-practical-cases/17-advanced-automation.md"
  "$DOCS_DIR/04-practical-cases/18-creative-applications.md"
  "$DOCS_DIR/04-practical-cases/19-solo-entrepreneur-cases.md"
)

# Convert each chapter
count=0
total=${#CHAPTERS[@]}

for chapter in "${CHAPTERS[@]}"; do
  count=$((count + 1))
  filename=$(basename "$chapter" .md)
  output="$OUTPUT_DIR/${filename}.docx"
  
  # Get chapter title from first line
  title=$(head -1 "$chapter" | sed 's/^# //')
  
  echo -e "${YELLOW}[$count/$total] 转换: $filename${NC}"
  echo "  标题: $title"
  
  pandoc "$chapter" \
    --from markdown \
    --to docx \
    --output "$output" \
    --standalone \
    --highlight-style=tango \
    --metadata title="$title"
  
  # Show file size
  size=$(ls -lh "$output" | awk '{print $5}')
  echo "  ✓ 完成: $size"
  echo ""
done

echo ""
echo -e "${GREEN}✓ 所有章节转换完成！${NC}"
echo ""
echo "生成的文件:"
ls -lh "$OUTPUT_DIR"/*.docx | awk '{print "  " $9 " (" $5 ")"}'
echo ""
echo "打开目录:"
echo "  open '$OUTPUT_DIR'"
