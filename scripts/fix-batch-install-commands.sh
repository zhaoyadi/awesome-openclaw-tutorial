#!/bin/bash

# 修复批量安装命令
# npx clawhub@latest install 一次只能安装一个 Skill

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}修复批量安装命令${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

FILE="docs/03-advanced/10-skills-extension.md"
BACKUP_FILE="${FILE}.batch-fix-$(date +%Y%m%d-%H%M%S)"

# 备份
echo -e "${YELLOW}1. 备份文件...${NC}"
cp "$FILE" "$BACKUP_FILE"
echo -e "${GREEN}   ✓ 已备份到: $BACKUP_FILE${NC}"
echo ""

# 查找所有批量安装的命令
echo -e "${YELLOW}2. 查找批量安装命令...${NC}"
grep -n "npx clawhub@latest install.*\s.*\s" "$FILE" | head -10
echo ""

echo -e "${YELLOW}3. 修复建议${NC}"
echo -e "${RED}   ❌ 错误示例:${NC}"
echo -e "   npx clawhub@latest install skill1 skill2 skill3"
echo ""
echo -e "${GREEN}   ✅ 正确示例:${NC}"
echo -e "   npx clawhub@latest install skill1"
echo -e "   npx clawhub@latest install skill2"
echo -e "   npx clawhub@latest install skill3"
echo ""
echo -e "   或使用循环:"
echo -e "   for skill in skill1 skill2 skill3; do"
echo -e "       npx clawhub@latest install \$skill"
echo -e "   done"
echo ""

# 创建修复后的示例
cat > /tmp/batch-install-fix.md << 'EOF'
## 批量安装 Skills 的正确方法

### ❌ 错误方法（不支持）
```bash
# 这样不行！clawhub install 一次只能安装一个 Skill
npx clawhub@latest install skill1 skill2 skill3
```

### ✅ 正确方法1：逐个安装
```bash
npx clawhub@latest install skill1
npx clawhub@latest install skill2
npx clawhub@latest install skill3
```

### ✅ 正确方法2：使用循环
```bash
# 定义要安装的 Skills
skills=(
    "mcporter"
    "brave-search"
    "file-system-manager"
    "playwright-headless"
)

# 循环安装
for skill in "${skills[@]}"; do
    echo "正在安装: $skill"
    npx clawhub@latest install "$skill"
done
```

### ✅ 正确方法3：使用脚本
```bash
#!/bin/bash
# install-skills.sh

SKILLS="mcporter brave-search file-system-manager playwright-headless"

for skill in $SKILLS; do
    echo "安装 $skill..."
    npx clawhub@latest install "$skill" || echo "⚠️ $skill 安装失败"
done

echo "✅ 批量安装完成"
```
EOF

echo -e "${YELLOW}4. 生成修复示例...${NC}"
cat /tmp/batch-install-fix.md
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}修复完成${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "📝 修复示例已生成: /tmp/batch-install-fix.md"
echo -e "💾 备份文件: $BACKUP_FILE"
echo ""
echo -e "${YELLOW}下一步:${NC}"
echo -e "1. 手动检查文档中的批量安装命令"
echo -e "2. 将批量安装改为循环安装"
echo -e "3. 添加正确的批量安装示例"
