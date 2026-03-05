#!/bin/bash

# 批量修复所有章节编号不一致问题

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}批量修复章节编号${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

BACKUP_DIR="backups/chapter-fix-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo -e "${YELLOW}1. 创建备份目录: $BACKUP_DIR${NC}"
echo ""

# 修复函数
fix_chapter() {
    local file=$1
    local old_num=$2
    local new_num=$3
    local desc=$4
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}   ✗ 文件不存在: $file${NC}"
        return
    fi
    
    # 备份
    cp "$file" "$BACKUP_DIR/$(basename $file)"
    
    # 修复
    sed -i '' "s/^### ${old_num}\./### ${new_num}./g" "$file"
    sed -i '' "s/^## ${old_num}\./## ${new_num}./g" "$file"
    
    echo -e "${GREEN}   ✓ $desc${NC}"
}

echo -e "${YELLOW}2. 开始修复章节编号...${NC}"
echo ""

# 第二部分：核心功能
echo -e "${BLUE}修复第二部分：核心功能${NC}"
fix_chapter "docs/02-core-features/07-knowledge-management.md" "5" "7" "第7章：5.x.x → 7.x.x"
fix_chapter "docs/02-core-features/08-schedule-management.md" "6" "8" "第8章：6.x.x → 8.x.x"
fix_chapter "docs/02-core-features/09-automation-workflow.md" "7" "9" "第9章：7.x.x → 9.x.x"
echo ""

# 第三部分：高级功能
echo -e "${BLUE}修复第三部分：高级功能${NC}"
fix_chapter "docs/03-advanced/14-api-integration.md" "10" "14" "第14章：10.x.x → 14.x.x"
fix_chapter "docs/03-advanced/15-advanced-configuration.md" "11" "15" "第15章：11.x.x → 15.x.x"
echo ""

# 第四部分：实战案例
echo -e "${BLUE}修复第四部分：实战案例${NC}"
fix_chapter "docs/04-practical-cases/15-personal-productivity.md" "11" "15" "第15章（实战）：11.x.x → 15.x.x"
fix_chapter "docs/04-practical-cases/16-advanced-automation.md" "12" "16" "第16章：12.x.x → 16.x.x"
fix_chapter "docs/04-practical-cases/17-creative-applications.md" "14" "17" "第17章：14.x.x → 17.x.x"
fix_chapter "docs/04-practical-cases/18-solo-entrepreneur-cases.md" "15" "18" "第18章：15.x.x → 18.x.x"
echo ""

echo -e "${YELLOW}3. 验证修复结果...${NC}"
echo ""

# 验证函数
verify_chapter() {
    local file=$1
    local expected=$2
    local desc=$3
    
    if [ ! -f "$file" ]; then
        return
    fi
    
    local wrong_count=$(grep -c "^##.* [0-9]\+\." "$file" | grep -v "^##.* ${expected}\." || echo "0")
    
    if [ "$wrong_count" -eq 0 ]; then
        echo -e "${GREEN}   ✓ $desc - 编号正确${NC}"
    else
        echo -e "${YELLOW}   ⚠ $desc - 可能还有问题${NC}"
    fi
}

verify_chapter "docs/02-core-features/07-knowledge-management.md" "7" "第7章"
verify_chapter "docs/02-core-features/08-schedule-management.md" "8" "第8章"
verify_chapter "docs/02-core-features/09-automation-workflow.md" "9" "第9章"
verify_chapter "docs/03-advanced/14-api-integration.md" "14" "第14章"
verify_chapter "docs/03-advanced/15-advanced-configuration.md" "15" "第15章"
verify_chapter "docs/04-practical-cases/15-personal-productivity.md" "15" "第15章（实战）"
verify_chapter "docs/04-practical-cases/16-advanced-automation.md" "16" "第16章"
verify_chapter "docs/04-practical-cases/17-creative-applications.md" "17" "第17章"
verify_chapter "docs/04-practical-cases/18-solo-entrepreneur-cases.md" "18" "第18章"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}修复完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}📝 备份目录: $BACKUP_DIR${NC}"
echo -e "${BLUE}📄 已修复: 9个章节${NC}"
echo ""
echo -e "${YELLOW}下一步：${NC}"
echo -e "1. 检查修复后的文件"
echo -e "2. 更新快速导航链接"
echo -e "3. 检查交叉引用"
echo -e "4. 如有问题，可从备份恢复"
