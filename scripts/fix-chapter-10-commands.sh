#!/bin/bash

# OpenClaw 教程第10章命令修复脚本
# 用途：批量修复第10章中的错误命令
# 作者：自动生成
# 日期：2026-02-20

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 文件路径
FILE="docs/03-advanced/10-skills-extension.md"
BACKUP_FILE="${FILE}.backup-$(date +%Y%m%d-%H%M%S)"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}OpenClaw 教程第10章命令修复脚本${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 检查文件是否存在
if [ ! -f "$FILE" ]; then
    echo -e "${RED}错误：文件不存在 $FILE${NC}"
    exit 1
fi

# 备份原文件
echo -e "${YELLOW}1. 备份原文件...${NC}"
cp "$FILE" "$BACKUP_FILE"
echo -e "${GREEN}   ✓ 已备份到: $BACKUP_FILE${NC}"
echo ""

# 统计需要修复的命令数量
echo -e "${YELLOW}2. 统计需要修复的命令...${NC}"
count_before=$(grep -c "openclaw skill " "$FILE" || true)
echo -e "   发现 ${RED}$count_before${NC} 处需要修复的命令"
echo ""

# 开始修复
echo -e "${YELLOW}3. 开始修复命令...${NC}"

# 修复 openclaw skill list -> openclaw skills list
echo -e "   修复: openclaw skill list → openclaw skills list"
sed -i.tmp 's/openclaw skill list/openclaw skills list/g' "$FILE"

# 修复 openclaw skill install -> npx clawhub@latest install
echo -e "   修复: openclaw skill install → npx clawhub@latest install"
sed -i.tmp 's/openclaw skill install/npx clawhub@latest install/g' "$FILE"

# 修复 openclaw skill uninstall -> npx clawhub@latest uninstall
echo -e "   修复: openclaw skill uninstall → npx clawhub@latest uninstall"
sed -i.tmp 's/openclaw skill uninstall/npx clawhub@latest uninstall/g' "$FILE"

# 修复 openclaw skill update -> npx clawhub@latest update
echo -e "   修复: openclaw skill update → npx clawhub@latest update"
sed -i.tmp 's/openclaw skill update/npx clawhub@latest update/g' "$FILE"

# 修复其他 openclaw skill 命令（标注为可能不可用）
echo -e "   修复: 其他 openclaw skill 命令 → 添加警告注释"

# openclaw skill check -> openclaw skills check (可能不可用)
sed -i.tmp 's/openclaw skill check/openclaw skills check/g' "$FILE"

# openclaw skill perf -> 标注为可能不可用
sed -i.tmp 's/openclaw skill perf/# ⚠️ 命令可能不可用: openclaw skill perf/g' "$FILE"

# openclaw skill backup -> 标注为可能不可用
sed -i.tmp 's/openclaw skill backup/# ⚠️ 命令可能不可用: openclaw skill backup/g' "$FILE"

# openclaw skill restore -> 标注为可能不可用
sed -i.tmp 's/openclaw skill restore/# ⚠️ 命令可能不可用: openclaw skill restore/g' "$FILE"

# openclaw skill logs -> 标注为可能不可用
sed -i.tmp 's/openclaw skill logs/# ⚠️ 命令可能不可用: openclaw skill logs/g' "$FILE"

# openclaw skill config -> 标注为可能不可用
sed -i.tmp 's/openclaw skill config/# ⚠️ 命令可能不可用: openclaw skill config/g' "$FILE"

# openclaw skill docs -> 标注为可能不可用
sed -i.tmp 's/openclaw skill docs/# ⚠️ 命令可能不可用: openclaw skill docs/g' "$FILE"

# openclaw skill priority -> 标注为可能不可用
sed -i.tmp 's/openclaw skill priority/# ⚠️ 命令可能不可用: openclaw skill priority/g' "$FILE"

# openclaw skill publish -> 标注为可能不可用
sed -i.tmp 's/openclaw skill publish/# ⚠️ 命令可能不可用: openclaw skill publish/g' "$FILE"

# openclaw skill feedback -> 标注为可能不可用
sed -i.tmp 's/openclaw skill feedback/# ⚠️ 命令可能不可用: openclaw skill feedback/g' "$FILE"

# openclaw skill reinstall -> 标注为可能不可用
sed -i.tmp 's/openclaw skill reinstall/# ⚠️ 命令可能不可用: openclaw skill reinstall/g' "$FILE"

# openclaw skill cache -> 标注为可能不可用
sed -i.tmp 's/openclaw skill cache/# ⚠️ 命令可能不可用: openclaw skill cache/g' "$FILE"

# 删除临时文件
rm -f "${FILE}.tmp"

echo -e "${GREEN}   ✓ 命令修复完成${NC}"
echo ""

# 统计修复后的命令数量
echo -e "${YELLOW}4. 验证修复结果...${NC}"
count_after=$(grep -c "openclaw skill " "$FILE" || true)
count_fixed=$((count_before - count_after))
echo -e "   修复前: ${RED}$count_before${NC} 处错误"
echo -e "   修复后: ${RED}$count_after${NC} 处错误"
echo -e "   已修复: ${GREEN}$count_fixed${NC} 处"
echo ""

# 显示剩余的问题（如果有）
if [ $count_after -gt 0 ]; then
    echo -e "${YELLOW}5. 剩余需要手动检查的命令:${NC}"
    grep -n "openclaw skill " "$FILE" | head -10
    echo ""
    echo -e "${YELLOW}   提示：以上命令可能需要手动检查和修复${NC}"
    echo ""
fi

# 生成修复报告
echo -e "${YELLOW}6. 生成修复报告...${NC}"
REPORT_FILE="CHAPTER-10-FIX-REPORT.md"
cat > "$REPORT_FILE" << EOF
# 第10章命令修复报告

## 修复时间
$(date '+%Y-%m-%d %H:%M:%S')

## 修复统计
- 修复前错误数量: $count_before
- 修复后错误数量: $count_after
- 成功修复数量: $count_fixed

## 修复内容

### 已修复的命令
1. \`openclaw skill list\` → \`openclaw skills list\`
2. \`openclaw skill install\` → \`npx clawhub@latest install\`
3. \`openclaw skill uninstall\` → \`npx clawhub@latest uninstall\`
4. \`openclaw skill update\` → \`npx clawhub@latest update\`
5. \`openclaw skill check\` → \`openclaw skills check\`

### 标注为可能不可用的命令
- \`openclaw skill perf\`
- \`openclaw skill backup\`
- \`openclaw skill restore\`
- \`openclaw skill logs\`
- \`openclaw skill config\`
- \`openclaw skill docs\`
- \`openclaw skill priority\`
- \`openclaw skill publish\`
- \`openclaw skill feedback\`
- \`openclaw skill reinstall\`
- \`openclaw skill cache\`

## 备份文件
原文件已备份到: \`$BACKUP_FILE\`

## 验证方法
\`\`\`bash
# 查看修复后的文件
cat $FILE | grep "openclaw skill"

# 如果需要恢复
cp $BACKUP_FILE $FILE
\`\`\`

## 建议
1. 运行 \`openclaw --help\` 查看实际可用的命令
2. 测试修复后的命令是否可用
3. 如有问题，可从备份文件恢复
EOF

echo -e "${GREEN}   ✓ 报告已生成: $REPORT_FILE${NC}"
echo ""

# 完成
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}修复完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "📝 修复报告: ${YELLOW}$REPORT_FILE${NC}"
echo -e "💾 备份文件: ${YELLOW}$BACKUP_FILE${NC}"
echo -e "📄 修复文件: ${YELLOW}$FILE${NC}"
echo ""
echo -e "${YELLOW}下一步操作:${NC}"
echo -e "1. 查看修复报告: ${GREEN}cat $REPORT_FILE${NC}"
echo -e "2. 验证修复结果: ${GREEN}grep 'openclaw skill' $FILE${NC}"
echo -e "3. 如需恢复: ${GREEN}cp $BACKUP_FILE $FILE${NC}"
echo ""
