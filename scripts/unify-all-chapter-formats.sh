#!/bin/bash

# 统一所有章节的标题格式
# 将 #### 1. 2. 3. 格式改为 ### X.1 X.2 X.3 格式

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}统一所有章节标题格式${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

BACKUP_DIR="backups/format-unify-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo -e "${YELLOW}1. 创建备份目录: $BACKUP_DIR${NC}"
echo ""

# 统一格式函数
unify_format() {
    local file=$1
    local chapter=$2
    local desc=$3
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}   ✗ 文件不存在: $file${NC}"
        return
    fi
    
    # 备份
    cp "$file" "$BACKUP_DIR/$(basename $file)"
    
    # 统一格式：#### 1. → ### X.1
    # 使用 awk 来处理，保持更精确的控制
    awk -v chapter="$chapter" '
    /^#### [0-9]+\./ {
        # 提取数字
        match($0, /^#### ([0-9]+)\./, arr)
        num = arr[1]
        # 获取标题文本（去掉前面的 #### 数字. ）
        sub(/^#### [0-9]+\. */, "")
        # 输出新格式
        print "### " chapter "." num " " $0
        next
    }
    { print }
    ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    
    echo -e "${GREEN}   ✓ $desc${NC}"
}

echo -e "${YELLOW}2. 开始统一格式...${NC}"
echo ""

# 第一部分：基础篇
echo -e "${BLUE}统一第一部分：基础篇${NC}"
unify_format "docs/01-basics/01-introduction.md" "1" "第1章：#### 1. → ### 1.1"
unify_format "docs/01-basics/02-installation.md" "2" "第2章：#### 1. → ### 2.1"
unify_format "docs/01-basics/04-maintenance-upgrade.md" "4" "第4章：#### 1. → ### 4.1"
echo ""

# 第三部分：高级功能（部分章节）
echo -e "${BLUE}统一第三部分：高级功能${NC}"
unify_format "docs/03-advanced/16-tools-policy.md" "16" "第16章：### 1. → ### 16.1"
unify_format "docs/03-advanced/17-node-management.md" "17" "第17章：### 1. → ### 17.1"
echo ""

echo -e "${YELLOW}3. 验证统一结果...${NC}"
echo ""

# 验证函数
verify_format() {
    local file=$1
    local desc=$2
    
    if [ ! -f "$file" ]; then
        return
    fi
    
    local old_format=$(grep -c "^#### [0-9]\+\." "$file" 2>/dev/null || echo "0")
    
    if [ "$old_format" -eq 0 ]; then
        echo -e "${GREEN}   ✓ $desc - 格式已统一${NC}"
    else
        echo -e "${YELLOW}   ⚠ $desc - 还有 $old_format 处旧格式${NC}"
    fi
}

verify_format "docs/01-basics/01-introduction.md" "第1章"
verify_format "docs/01-basics/02-installation.md" "第2章"
verify_format "docs/01-basics/04-maintenance-upgrade.md" "第4章"
verify_format "docs/03-advanced/16-tools-policy.md" "第16章"
verify_format "docs/03-advanced/17-node-management.md" "第17章"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}格式统一完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}📝 备份目录: $BACKUP_DIR${NC}"
echo -e "${BLUE}📄 已处理: 5个章节${NC}"
echo ""
echo -e "${YELLOW}统一后的格式示例：${NC}"
echo -e "  #### 1. 本地部署  →  ### 1.1 本地部署"
echo -e "  #### 2. 访问文件  →  ### 1.2 访问文件"
echo ""
echo -e "${YELLOW}下一步：${NC}"
echo -e "1. 检查统一后的文件"
echo -e "2. 验证标题层级是否正确"
echo -e "3. 更新目录和导航"
echo -e "4. 如有问题，可从备份恢复"
