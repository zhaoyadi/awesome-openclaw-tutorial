#!/bin/bash

# 修复第10章所有批量安装命令
# npx clawhub@latest install 一次只能安装一个 Skill

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}修复第10章批量安装命令${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

FILE="docs/03-advanced/10-skills-extension.md"
BACKUP_FILE="${FILE}.batch-fix-$(date +%Y%m%d-%H%M%S)"

# 备份
echo -e "${YELLOW}1. 备份文件...${NC}"
cp "$FILE" "$BACKUP_FILE"
echo -e "${GREEN}   ✓ 已备份到: $BACKUP_FILE${NC}"
echo ""

# 统计需要修复的位置
echo -e "${YELLOW}2. 检测批量安装命令...${NC}"
BATCH_COUNT=$(grep -c "npx clawhub@latest install.*\s.*\s" "$FILE" || true)
echo -e "${BLUE}   发现 ${BATCH_COUNT} 处批量安装命令${NC}"
echo ""

# 显示所有需要修复的行
echo -e "${YELLOW}3. 需要修复的位置：${NC}"
grep -n "npx clawhub@latest install.*\s.*\s" "$FILE" | head -10
echo ""

# 开始修复
echo -e "${YELLOW}4. 开始修复...${NC}"

# 使用 sed 进行批量替换
# 注意：macOS 的 sed 需要 -i '' 参数

# 修复1：行647 - 安装多个Skills示例
sed -i '' '647s|npx clawhub@latest install file-search note-sync calendar-sync|# 方法1：逐个安装\
npx clawhub@latest install file-search\
npx clawhub@latest install note-sync\
npx clawhub@latest install calendar-sync\
\
# 方法2：使用循环\
for skill in file-search note-sync calendar-sync; do\
    npx clawhub@latest install "$skill"\
done|' "$FILE"

echo -e "${GREEN}   ✓ 修复位置1: 行647 (安装多个Skills示例)${NC}"

# 修复2：行1084 - 基础套装
sed -i '' '1084s|npx clawhub@latest install calendar-sync file-search web-clipper|# 逐个安装\
for skill in calendar-sync file-search web-clipper; do\
    npx clawhub@latest install "$skill"\
done|' "$FILE"

echo -e "${GREEN}   ✓ 修复位置2: 行1084 (基础套装)${NC}"

# 修复3：行1087 - 进阶套装
sed -i '' '1087s|npx clawhub@latest install scheduler note-sync file-organizer|# 逐个安装\
for skill in scheduler note-sync file-organizer; do\
    npx clawhub@latest install "$skill"\
done|' "$FILE"

echo -e "${GREEN}   ✓ 修复位置3: 行1087 (进阶套装)${NC}"

# 修复4：行1090-1093 - 完整套装（多行）
sed -i '' '1090,1093s|npx clawhub@latest install calendar-sync file-search web-clipper \\|# 逐个安装\
skills=(\
    "calendar-sync"\
    "file-search"\
    "web-clipper"\
    "scheduler"\
    "note-sync"\
    "file-organizer"\
    "screenshot"\
    "reminder"\
    "batch-processor"\
    "translator"\
)\
\
for skill in "${skills[@]}"; do\
    echo "正在安装: $skill"\
    npx clawhub@latest install "$skill" \|\| echo "⚠️ $skill 安装失败"\
done|' "$FILE"

echo -e "${GREEN}   ✓ 修复位置4: 行1090-1093 (完整套装)${NC}"

# 修复5：行1237-1240 - 8大核心Skills
sed -i '' '1237,1240s|npx clawhub@latest install mcporter brave-search \\|# 逐个安装8大核心Skills\
skills=(\
    "mcporter"\
    "brave-search"\
    "file-system-manager"\
    "playwright-headless"\
    "design-doc-mermaid"\
    "google-workspace"\
    "find-skills"\
    "proactive-agent"\
)\
\
for skill in "${skills[@]}"; do\
    echo "正在安装: $skill"\
    npx clawhub@latest install "$skill" \|\| echo "⚠️ $skill 安装失败"\
done|' "$FILE"

echo -e "${GREEN}   ✓ 修复位置5: 行1237-1240 (8大核心Skills)${NC}"

# 修复6：行1264 - 安装多个技能
sed -i '' '1264s|npx clawhub@latest install brave-search file-system-manager|# 逐个安装\
npx clawhub@latest install brave-search\
npx clawhub@latest install file-system-manager|' "$FILE"

echo -e "${GREEN}   ✓ 修复位置6: 行1264 (安装多个技能)${NC}"

# 修复7：行1372 - 团队协作Skills
sed -i '' '1372s|npx clawhub@latest install github linear-integration slack-bot google-workspace|# 逐个安装\
for skill in github linear-integration slack-bot google-workspace; do\
    npx clawhub@latest install "$skill"\
done|' "$FILE"

echo -e "${GREEN}   ✓ 修复位置7: 行1372 (团队协作Skills)${NC}"

# 修复8：行1399 - 智能家居Skills
sed -i '' '1399s|npx clawhub@latest install home-assistant weather-api location-tracker automation-scheduler|# 逐个安装\
for skill in home-assistant weather-api location-tracker automation-scheduler; do\
    npx clawhub@latest install "$skill"\
done|' "$FILE"

echo -e "${GREEN}   ✓ 修复位置8: 行1399 (智能家居Skills)${NC}"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}修复完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 验证修复结果
echo -e "${YELLOW}5. 验证修复结果...${NC}"
REMAINING=$(grep -c "npx clawhub@latest install.*\s.*\s" "$FILE" || true)
echo -e "${BLUE}   剩余批量安装命令: ${REMAINING}${NC}"
echo ""

if [ "$REMAINING" -eq 0 ]; then
    echo -e "${GREEN}✅ 所有批量安装命令已修复！${NC}"
else
    echo -e "${YELLOW}⚠️ 还有 ${REMAINING} 处需要手动检查${NC}"
    echo ""
    echo -e "${YELLOW}剩余位置：${NC}"
    grep -n "npx clawhub@latest install.*\s.*\s" "$FILE"
fi

echo ""
echo -e "${BLUE}📝 备份文件: $BACKUP_FILE${NC}"
echo -e "${BLUE}📄 修复文件: $FILE${NC}"
echo ""
echo -e "${YELLOW}下一步：${NC}"
echo -e "1. 查看修复后的文件"
echo -e "2. 测试安装命令"
echo -e "3. 如有问题，可从备份恢复"
