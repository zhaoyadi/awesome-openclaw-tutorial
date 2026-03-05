#!/usr/bin/env bash
# 转换附录为DOCX

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APPENDIX_DIR="$PROJECT_ROOT/appendix"
OUTPUT_DIR="$PROJECT_ROOT/output"

# Check pandoc
if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is not installed"
    echo "Install it with: brew install pandoc"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo -e "${GREEN}转换附录为DOCX...${NC}"
echo ""

# 转换附录
echo -e "${YELLOW}转换附录部分...${NC}"
pandoc \
  "$APPENDIX_DIR"/A-command-reference.md \
  "$APPENDIX_DIR"/B-skills-catalog.md \
  "$APPENDIX_DIR"/C-api-comparison.md \
  "$APPENDIX_DIR"/D-community-resources.md \
  "$APPENDIX_DIR"/E-common-problems.md \
  "$APPENDIX_DIR"/F-best-practices.md \
  "$APPENDIX_DIR"/G-links-validation.md \
  "$APPENDIX_DIR"/I-thinking-questions-answers.md \
  "$APPENDIX_DIR"/J-feishu-checklist.md \
  "$APPENDIX_DIR"/K-api-key-config-guide.md \
  "$APPENDIX_DIR"/L-config-file-structure.md \
  "$APPENDIX_DIR"/M-search-guide.md \
  "$APPENDIX_DIR"/N-skills-ecosystem.md \
  --from markdown --to docx \
  --output "$OUTPUT_DIR/appendix.docx" \
  --standalone --toc --toc-depth=3 \
  --metadata title="OpenClaw教程 - 附录"

echo ""
echo -e "${GREEN}✓ 附录转换完成！${NC}"
echo ""
echo "生成的文件:"
echo "  - $OUTPUT_DIR/appendix.docx"
echo ""
echo "打开文件:"
echo "  open '$OUTPUT_DIR/appendix.docx'"
