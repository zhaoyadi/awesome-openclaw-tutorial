#!/bin/bash

# 为第11章和第12章添加数字编号

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}为第11章和第12章添加数字编号${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

BACKUP_DIR="backups/add-numbers-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 第11章
FILE="docs/03-advanced/11-multi-platform-integration.md"
echo -e "${YELLOW}处理第11章...${NC}"
cp "$FILE" "$BACKUP_DIR/"

# 添加编号（按出现顺序）
sed -i '' 's/^## 为什么需要多平台集成？/## 11.1 为什么需要多平台集成？/g' "$FILE"
sed -i '' 's/^## 平台选择指南/## 11.2 平台选择指南/g' "$FILE"
sed -i '' 's/^### 国内用户推荐/### 11.2.1 国内用户推荐/g' "$FILE"
sed -i '' 's/^### 国外用户推荐/### 11.2.2 国外用户推荐/g' "$FILE"
sed -i '' 's/^## 平台对比与选择/## 11.3 平台对比与选择/g' "$FILE"
sed -i '' 's/^### 功能对比表/### 11.3.1 功能对比表/g' "$FILE"
sed -i '' 's/^### 使用场景对比/### 11.3.2 使用场景对比/g' "$FILE"
sed -i '' 's/^## 配置前的准备/## 11.4 配置前的准备/g' "$FILE"
sed -i '' 's/^## 快速配置向导/## 11.5 快速配置向导/g' "$FILE"

echo -e "${GREEN}✓ 第11章完成${NC}"

# 第12章
FILE="docs/03-advanced/12-feishu-bot.md"
echo -e "${YELLOW}处理第12章...${NC}"
cp "$FILE" "$BACKUP_DIR/"

# 添加编号
sed -i '' 's/^## 飞书机器人介绍/## 12.1 飞书机器人介绍/g' "$FILE"
sed -i '' 's/^### 为什么选择飞书？/### 12.1.1 为什么选择飞书？/g' "$FILE"
sed -i '' 's/^### 适用场景/### 12.1.2 适用场景/g' "$FILE"
sed -i '' 's/^## 快速开始/## 12.2 快速开始/g' "$FILE"
sed -i '' 's/^### 前置要求/### 12.2.1 前置要求/g' "$FILE"
sed -i '' 's/^### 配置流程概览/### 12.2.2 配置流程概览/g' "$FILE"
sed -i '' 's/^## 创建飞书应用/## 12.3 创建飞书应用/g' "$FILE"
sed -i '' 's/^### 步骤1：访问飞书开放平台/### 12.3.1 步骤1：访问飞书开放平台/g' "$FILE"
sed -i '' 's/^### 步骤2：创建企业自建应用/### 12.3.2 步骤2：创建企业自建应用/g' "$FILE"
sed -i '' 's/^### 步骤3：获取凭证信息/### 12.3.3 步骤3：获取凭证信息/g' "$FILE"
sed -i '' 's/^### 步骤4：配置应用权限/### 12.3.4 步骤4：配置应用权限/g' "$FILE"
sed -i '' 's/^### 步骤5：配置事件订阅/### 12.3.5 步骤5：配置事件订阅/g' "$FILE"
sed -i '' 's/^## 配置OpenClaw/## 12.4 配置OpenClaw/g' "$FILE"
sed -i '' 's/^### 方式一：使用配置向导（推荐）/### 12.4.1 方式一：使用配置向导（推荐）/g' "$FILE"
sed -i '' 's/^### 方式二：手动配置/### 12.4.2 方式二：手动配置/g' "$FILE"
sed -i '' 's/^## 启动和测试/## 12.5 启动和测试/g' "$FILE"
sed -i '' 's/^### 启动Gateway/### 12.5.1 启动Gateway/g' "$FILE"
sed -i '' 's/^### 测试连接/### 12.5.2 测试连接/g' "$FILE"
sed -i '' 's/^## 高级功能/## 12.6 高级功能/g' "$FILE"
sed -i '' 's/^## 常见问题/## 12.7 常见问题/g' "$FILE"
sed -i '' 's/^## 最佳实践/## 12.8 最佳实践/g' "$FILE"

echo -e "${GREEN}✓ 第12章完成${NC}"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}编号添加完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}📝 备份目录: $BACKUP_DIR${NC}"
echo ""

# 验证
echo -e "${YELLOW}验证结果：${NC}"
echo -e "${BLUE}第11章：${NC}"
grep "^## 11\." docs/03-advanced/11-multi-platform-integration.md | head -5
echo ""
echo -e "${BLUE}第12章：${NC}"
grep "^## 12\." docs/03-advanced/12-feishu-bot.md | head -5
