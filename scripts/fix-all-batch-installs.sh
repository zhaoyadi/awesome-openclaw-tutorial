#!/bin/bash

# 修复所有批量安装命令
# npx clawhub@latest install 一次只能安装一个 Skill

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}修复第10章所有批量安装命令${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

FILE="docs/03-advanced/10-skills-extension.md"
BACKUP_FILE="${FILE}.batch-fix-$(date +%Y%m%d-%H%M%S)"

# 备份
echo -e
