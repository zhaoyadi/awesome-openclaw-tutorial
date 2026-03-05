#!/usr/bin/env bash
# 最终修复所有章节编号问题

set -euo pipefail

echo "🔧 开始修复所有章节编号问题..."
echo ""

# 1. 修复第12章标题
echo "1️⃣ 修复第12章标题..."
sed -i '' 's/^# 第9\.1章：飞书Bot配置/# 第12章：飞书Bot配置/' \
  awesome-openclaw-tutorial/docs/03-advanced/12-feishu-bot.md

# 2. 修复第11章 - 添加缺失的11.1节
echo "2️⃣ 修复第11章编号..."
file="awesome-openclaw-tutorial/docs/03-advanced/11-multi-platform-integration.md"

# 检查是否有11.1开头的内容
if ! grep -q "^### 11\.1" "$file"; then
  # 在11.2.1之前添加11.1节
  sed -i '' '/^### 11\.2\.1/i\
### 11.1 平台选择指南\
' "$file"
fi

echo ""
echo "✅ 所有章节编号问题已修复！"
echo ""
echo "修复内容："
echo "  - 第12章标题: 第9.1章 → 第12章"
echo "  - 第11章: 添加缺失的11.1节"
echo ""
echo "注意: 第7-10章和第14-18章使用三级编号(X.Y.Z)是正常的，因为内容较多"
