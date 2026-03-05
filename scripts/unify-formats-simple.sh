#!/bin/bash

# 简单可靠的格式统一脚本
# 使用 sed 逐个替换

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}统一章节标题格式（简化版）${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

BACKUP_DIR="backups/format-simple-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 第1章
FILE="docs/01-basics/01-introduction.md"
echo -e "${YELLOW}处理第1章...${NC}"
cp "$FILE" "$BACKUP_DIR/"
sed -i '' 's/^#### 1\. /### 1.1 /g' "$FILE"
sed -i '' 's/^#### 2\. /### 1.2 /g' "$FILE"
sed -i '' 's/^#### 3\. /### 1.3 /g' "$FILE"
sed -i '' 's/^#### 4\. /### 1.4 /g' "$FILE"
sed -i '' 's/^#### 5\. /### 1.5 /g' "$FILE"
echo -e "${GREEN}✓ 第1章完成${NC}"

# 第2章
FILE="docs/01-basics/02-installation.md"
echo -e "${YELLOW}处理第2章...${NC}"
cp "$FILE" "$BACKUP_DIR/"
sed -i '' 's/^#### 1\. /### 2.1 /g' "$FILE"
sed -i '' 's/^#### 2\. /### 2.2 /g' "$FILE"
sed -i '' 's/^#### 3\. /### 2.3 /g' "$FILE"
echo -e "${GREEN}✓ 第2章完成${NC}"

# 第4章
FILE="docs/01-basics/04-maintenance-upgrade.md"
echo -e "${YELLOW}处理第4章...${NC}"
cp "$FILE" "$BACKUP_DIR/"
sed -i '' 's/^#### 1\. /### 4.1 /g' "$FILE"
sed -i '' 's/^#### 2\. /### 4.2 /g' "$FILE"
sed -i '' 's/^#### 3\. /### 4.3 /g' "$FILE"
sed -i '' 's/^#### 4\. /### 4.4 /g' "$FILE"
echo -e "${GREEN}✓ 第4章完成${NC}"

# 第16章
FILE="docs/03-advanced/16-tools-policy.md"
echo -e "${YELLOW}处理第16章...${NC}"
cp "$FILE" "$BACKUP_DIR/"
sed -i '' 's/^### 1\. /### 16.1 /g' "$FILE"
sed -i '' 's/^### 2\. /### 16.2 /g' "$FILE"
sed -i '' 's/^### 3\. /### 16.3 /g' "$FILE"
sed -i '' 's/^### 4\. /### 16.4 /g' "$FILE"
echo -e "${GREEN}✓ 第16章完成${NC}"

# 第17章
FILE="docs/03-advanced/17-node-management.md"
echo -e "${YELLOW}处理第17章...${NC}"
cp "$FILE" "$BACKUP_DIR/"
sed -i '' 's/^### 1\. /### 17.1 /g' "$FILE"
sed -i '' 's/^### 2\. /### 17.2 /g' "$FILE"
sed -i '' 's/^### 3\. /### 17.3 /g' "$FILE"
echo -e "${GREEN}✓ 第17章完成${NC}"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}格式统一完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}📝 备份目录: $BACKUP_DIR${NC}"
echo ""

# 验证
echo -e "${YELLOW}验证结果：${NC}"
for file in docs/01-basics/01-introduction.md docs/01-basics/02-installation.md docs/01-basics/04-maintenance-upgrade.md docs/03-advanced/16-tools-policy.md docs/03-advanced/17-node-management.md; do
    count=$(grep -c "^#### [0-9]\+\." "$file" 2>/dev/null || echo "0")
    if [ "$count" -eq 0 ]; then
        echo -e "${GREEN}✓ $(basename $file) - 格式已统一${NC}"
    else
        echo -e "${YELLOW}⚠ $(basename $file) - 还有 $count 处旧格式${NC}"
    fi
done
