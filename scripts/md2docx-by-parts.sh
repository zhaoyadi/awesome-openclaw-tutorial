#!/usr/bin/env bash
# 分部分转换Markdown为DOCX (更快)

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOCS_DIR="$PROJECT_ROOT/docs"
OUTPUT_DIR="$PROJECT_ROOT/output"

# Check pandoc
if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is not installed"
    echo "Install it with: brew install pandoc"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo -e "${GREEN}分部分转换DOCX文档...${NC}"
echo ""

# Part 1: 基础入门 (1-5章)
echo -e "${YELLOW}转换第1部分: 基础入门 (1-5章)...${NC}"
pandoc \
  "$DOCS_DIR"/01-basics/01-introduction.md \
  "$DOCS_DIR"/01-basics/02-installation.md \
  "$DOCS_DIR"/01-basics/03-advanced-deployment.md \
  "$DOCS_DIR"/01-basics/04-maintenance-upgrade.md \
  "$DOCS_DIR"/01-basics/05-quick-start.md \
  --from markdown --to docx \
  --output "$OUTPUT_DIR/part1-basics.docx" \
  --standalone --toc --toc-depth=3 \
  --metadata title="OpenClaw教程 - 第1部分: 基础入门"

# Part 2: 核心功能 (6-9章)
echo -e "${YELLOW}转换第2部分: 核心功能 (6-9章)...${NC}"
pandoc \
  "$DOCS_DIR"/02-core-features/06-file-management.md \
  "$DOCS_DIR"/02-core-features/07-knowledge-management.md \
  "$DOCS_DIR"/02-core-features/08-schedule-management.md \
  "$DOCS_DIR"/02-core-features/09-automation-workflow.md \
  --from markdown --to docx \
  --output "$OUTPUT_DIR/part2-core-features.docx" \
  --standalone --toc --toc-depth=3 \
  --metadata title="OpenClaw教程 - 第2部分: 核心功能"

# Part 3: 高级特性 (10-15章)
echo -e "${YELLOW}转换第3部分: 高级特性 (10-15章)...${NC}"
pandoc \
  "$DOCS_DIR"/03-advanced/10-skills-extension.md \
  "$DOCS_DIR"/03-advanced/11-multi-platform-integration.md \
  "$DOCS_DIR"/03-advanced/12-feishu-bot.md \
  "$DOCS_DIR"/03-advanced/13-wework-dingtalk-qq.md \
  "$DOCS_DIR"/03-advanced/14-api-integration.md \
  "$DOCS_DIR"/03-advanced/15-advanced-configuration.md \
  --from markdown --to docx \
  --output "$OUTPUT_DIR/part3-advanced.docx" \
  --standalone --toc --toc-depth=3 \
  --metadata title="OpenClaw教程 - 第3部分: 高级特性"

# Part 4: 实战案例 (16-19章)
echo -e "${YELLOW}转换第4部分: 实战案例 (16-19章)...${NC}"
pandoc \
  "$DOCS_DIR"/04-practical-cases/16-personal-productivity.md \
  "$DOCS_DIR"/04-practical-cases/17-advanced-automation.md \
  "$DOCS_DIR"/04-practical-cases/18-creative-applications.md \
  "$DOCS_DIR"/04-practical-cases/19-solo-entrepreneur-cases.md \
  --from markdown --to docx \
  --output "$OUTPUT_DIR/part4-practical-cases.docx" \
  --standalone --toc --toc-depth=3 \
  --metadata title="OpenClaw教程 - 第4部分: 实战案例"

echo ""
echo -e "${GREEN}✓ 转换完成！${NC}"
echo ""
echo "生成的文件:"
echo "  - $OUTPUT_DIR/part1-basics.docx (基础入门)"
echo "  - $OUTPUT_DIR/part2-core-features.docx (核心功能)"
echo "  - $OUTPUT_DIR/part3-advanced.docx (高级特性)"
echo "  - $OUTPUT_DIR/part4-practical-cases.docx (实战案例)"
echo ""
echo "打开文件:"
echo "  open '$OUTPUT_DIR'"
