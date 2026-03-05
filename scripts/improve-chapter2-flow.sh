#!/usr/bin/env bash
# 优化第2章的上下文衔接和目录格式

set -euo pipefail

CHAPTER_FILE="awesome-openclaw-tutorial/docs/01-basics/02-installation.md"

echo "🔧 优化第2章内容..."
echo ""

# 备份原文件
cp "$CHAPTER_FILE" "${CHAPTER_FILE}.backup-$(date +%Y%m%d-%H%M%S)"

# 1. 删除目录中的标点符号
echo "1️⃣ 删除目录标点符号..."
sed -i '' 's/为什么推荐飞书（国内）？/为什么推荐飞书（国内）/g' "$CHAPTER_FILE"
sed -i '' 's/为什么推荐Telegram（国外）？/为什么推荐Telegram（国外）/g' "$CHAPTER_FILE"

# 2. 删除重复的Mac本地部署内容（保留第一个完整版本）
echo "2️⃣ 删除重复内容..."
# 这部分需要手动处理，因为涉及大段文本

echo ""
echo "✅ 基础优化完成！"
echo ""
echo "⚠️  需要手动优化的部分："
echo "  1. 删除重复的Mac本地部署内容（第二个版本）"
echo "  2. 添加章节之间的过渡语"
echo "  3. 优化内容衔接"
