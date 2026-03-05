#!/bin/bash

# 删除第15章中的Antigravity Manager内容

FILE="awesome-openclaw-tutorial/docs/03-advanced/15-advanced-configuration.md"

echo "正在删除第15章中的Antigravity Manager内容..."

# 使用 sed 删除 Antigravity Manager 相关内容
# 1. 删除本章内容列表中的 Antigravity Manager 行
# 2. 删除整个 Antigravity Manager 章节（从 ## Antigravity Manager 到下一个 ## 之前）
# 3. 删除章节开头的 Antigravity Manager 提及
# 4. 删除本章小结中的 Antigravity Manager 提及

# 创建临时文件
TMP_FILE=$(mktemp)

# 使用 awk 处理文件
awk '
BEGIN { skip = 0; in_toc = 0; in_summary = 0 }

# 检测本章内容部分
/^## ⚙️ 本章内容/ { in_toc = 1; print; next }

# 在本章内容部分，跳过 Antigravity Manager 行
in_toc == 1 && /^- 11\.1 Antigravity Manager完全配置指南/ { next }

# 本章内容部分结束
in_toc == 1 && /^---/ { in_toc = 0; print; next }

# 检测 Antigravity Manager 章节开始
/^## Antigravity Manager完全配置指南/ { skip = 1; next }

# 检测下一个二级标题（章节结束）
skip == 1 && /^## [^A]/ { skip = 0 }

# 跳过 Antigravity Manager 章节内容
skip == 1 { next }

# 检测本章小结部分
/^## 【说明】 本章小结/ { in_summary = 1; print; next }

# 在本章小结的核心内容部分，删除 Antigravity Manager 行
in_summary == 1 && /^1\. \*\*Antigravity Manager配置\*\* - API 统一管理/ { next }

# 本章小结结束
in_summary == 1 && /^---/ { in_summary = 0; print; next }

# 打印其他所有行
{ print }
' "$FILE" > "$TMP_FILE"

# 替换原文件
mv "$TMP_FILE" "$FILE"

echo "✓ 已删除 Antigravity Manager 相关内容"
echo "✓ 文件已更新: $FILE"
