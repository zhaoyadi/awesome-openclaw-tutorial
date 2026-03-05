#!/bin/bash

# 为第2、3、4、5章添加数字编号

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}为第2、3、4、5章添加数字编号${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

BACKUP_DIR="backups/add-numbers-ch2-5-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 第2章
FILE="docs/01-basics/02-installation.md"
echo -e "${YELLOW}处理第2章...${NC}"
cp "$FILE" "$BACKUP_DIR/"

sed -i '' 's/^## Mac本地部署（推荐）/## 2.1 Mac本地部署（推荐）/g' "$FILE"
sed -i '' 's/^## 云端一键部署/## 2.2 云端一键部署/g' "$FILE"
sed -i '' 's/^## 国内一键安装（快速版）/## 2.3 国内一键安装（快速版）/g' "$FILE"
sed -i '' 's/^## 快速API配置/## 2.4 快速API配置/g' "$FILE"
sed -i '' 's/^## 常见问题/## 2.5 常见问题/g' "$FILE"
sed -i '' 's/^## 本章小结/## 2.6 本章小结/g' "$FILE"

echo -e "${GREEN}✓ 第2章完成${NC}"

# 第3章
FILE="docs/01-basics/03-advanced-deployment.md"
echo -e "${YELLOW}处理第3章...${NC}"
cp "$FILE" "$BACKUP_DIR/"

sed -i '' 's/^## Windows本地部署/## 3.1 Windows本地部署/g' "$FILE"
sed -i '' 's/^## Linux本地部署/## 3.2 Linux本地部署/g' "$FILE"
sed -i '' 's/^## 国内一键安装（完整版）/## 3.3 国内一键安装（完整版）/g' "$FILE"
sed -i '' 's/^## Cloudflare Workers部署/## 3.4 Cloudflare Workers部署/g' "$FILE"
sed -i '' 's/^## Docker部署/## 3.5 Docker部署/g' "$FILE"
sed -i '' 's/^## 本章小结/## 3.6 本章小结/g' "$FILE"

echo -e "${GREEN}✓ 第3章完成${NC}"

# 第4章
FILE="docs/01-basics/04-maintenance-upgrade.md"
echo -e "${YELLOW}处理第4章...${NC}"
cp "$FILE" "$BACKUP_DIR/"

sed -i '' 's/^## 更新和维护/## 4.1 更新和维护/g' "$FILE"
sed -i '' 's/^## API配置详解/## 4.2 API配置详解/g' "$FILE"
sed -i '' 's/^## 版本升级指南/## 4.3 版本升级指南/g' "$FILE"
sed -i '' 's/^## 本章小结/## 4.4 本章小结/g' "$FILE"

echo -e "${GREEN}✓ 第4章完成${NC}"

# 第5章
FILE="docs/01-basics/05-quick-start.md"
echo -e "${YELLOW}处理第5章...${NC}"
cp "$FILE" "$BACKUP_DIR/"

sed -i '' 's/^## 第一次对话$/## 5.1 第一次对话/g' "$FILE"
sed -i '' 's/^## 基本命令使用$/## 5.2 基本命令使用/g' "$FILE"
sed -i '' 's/^## 人设配置技巧$/## 5.3 人设配置技巧/g' "$FILE"

echo -e "${GREEN}✓ 第5章完成${NC}"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}编号添加完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}📝 备份目录: $BACKUP_DIR${NC}"
echo ""

# 验证
echo -e "${YELLOW}验证结果：${NC}"
echo -e "${BLUE}第2章：${NC}"
grep "^## 2\." docs/01-basics/02-installation.md
echo ""
echo -e "${BLUE}第3章：${NC}"
grep "^## 3\." docs/01-basics/03-advanced-deployment.md
echo ""
echo -e "${BLUE}第4章：${NC}"
grep "^## 4\." docs/01-basics/04-maintenance-upgrade.md
echo ""
echo -e "${BLUE}第5章：${NC}"
grep "^## 5\." docs/01-basics/05-quick-start.md
