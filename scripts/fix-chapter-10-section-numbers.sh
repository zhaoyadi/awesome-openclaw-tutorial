#!/bin/bash

# 修复第10章的章节编号
# 将所有 8.x 改为 10.x

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}修复第10章章节编号${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

FILE="docs/03-advanced/10-skills-extension.md"
BACKUP_FILE="${FILE}.section-fix-$(date +%Y%m%d-%H%M%S)"

# 备份
echo -e "${YELLOW}1. 备份文件...${NC}"
cp "$FILE" "$BACKUP_FILE"
echo -e "${GREEN}   ✓ 已备份到: $BACKUP_FILE${NC}"
echo ""

# 统计需要修复的位置
echo -e "${YELLOW}2. 检测章节编号...${NC}"
SECTION_COUNT=$(grep -c "^##.* 8\." "$FILE" || true)
echo -e "${BLUE}   发现 ${SECTION_COUNT} 处需要修复的章节编号${NC}"
echo ""

# 显示需要修复的行
echo -e "${YELLOW}3. 需要修复的位置（前20个）：${NC}"
grep -n "^##.* 8\." "$FILE" | head -20
echo ""

# 开始修复
echo -e "${YELLOW}4. 开始修复...${NC}"

# 使用 sed 批量替换所有 8.x 为 10.x
# macOS 的 sed 需要 -i '' 参数
sed -i '' 's/^### 8\./### 10./g' "$FILE"
sed -i '' 's/^## 8\./## 10./g' "$FILE"

# 修复快速导航中的链接
sed -i '' 's/#80-/#100-/g' "$FILE"
sed -i '' 's/#81-/#101-/g' "$FILE"
sed -i '' 's/#82-/#102-/g' "$FILE"
sed -i '' 's/#83-/#103-/g' "$FILE"
sed -i '' 's/#84-/#104-/g' "$FILE"
sed -i '' 's/#85-/#105-/g' "$FILE"

echo -e "${GREEN}   ✓ 已修复所有章节编号${NC}"
echo ""

# 验证修复结果
echo -e "${YELLOW}5. 验证修复结果...${NC}"
REMAINING=$(grep -c "^##.* 8\." "$FILE" || true)
echo -e "${BLUE}   剩余 8.x 编号: ${REMAINING}${NC}"
echo ""

if [ "$REMAINING" -eq 0 ]; then
    echo -e "${GREEN}✅ 所有章节编号已修复为 10.x！${NC}"
else
    echo -e "${YELLOW}⚠️ 还有 ${REMAINING} 处需要手动检查${NC}"
    echo ""
    echo -e "${YELLOW}剩余位置：${NC}"
    grep -n "^##.* 8\." "$FILE"
fi

echo ""
echo -e "${BLUE}📝 备份文件: $BACKUP_FILE${NC}"
echo -e "${BLUE}📄 修复文件: $FILE${NC}"
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}修复完成！${NC}"
echo -e "${GREEN}========================================${NC}"
