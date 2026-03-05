#!/bin/bash

# 第2章格式规范化脚本
# 基于清华大学出版社书稿要求

FILE="awesome-openclaw-tutorial/docs/01-basics/02-installation.md"

echo "开始修复第2章格式问题..."
echo ""

# 1. 删除所有【】符号
echo "1. 删除【】符号..."
sed -i '' 's/【Mac】//g' "$FILE"
sed -i '' 's/【Windows】//g' "$FILE"
sed -i '' 's/【Linux】//g' "$FILE"
sed -i '' 's/【国外】//g' "$FILE"
sed -i '' 's/【国内】//g' "$FILE"
sed -i '' 's/【本地】//g' "$FILE"
sed -i '' 's/【云端】//g' "$FILE"
sed -i '' 's/【快速】//g' "$FILE"
sed -i '' 's/【成本】//g' "$FILE"
sed -i '' 's/【手机】//g' "$FILE"
sed -i '' 's/【安全】//g' "$FILE"
sed -i '' 's/【配置】//g' "$FILE"
sed -i '' 's/【启动】//g' "$FILE"
sed -i '' 's/【对话】//g' "$FILE"
sed -i '' 's/【文件夹】//g' "$FILE"
sed -i '' 's/【搜索】//g' "$FILE"
sed -i '' 's/【文档】//g' "$FILE"
sed -i '' 's/【说明】//g' "$FILE"
sed -i '' 's/【数据】//g' "$FILE"
sed -i '' 's/【目标】//g' "$FILE"
sed -i '' 's/【AI】//g' "$FILE"
sed -i '' 's/【网络】//g' "$FILE"
sed -i '' 's/【包】//g' "$FILE"
sed -i '' 's/【设计】//g' "$FILE"
sed -i '' 's/【智能】//g' "$FILE"
sed -i '' 's/【文件】//g' "$FILE"
sed -i '' 's/【趋势】//g' "$FILE"
sed -i '' 's/【清理】//g' "$FILE"
sed -i '' 's/【脚本】//g' "$FILE"
sed -i '' 's/【密钥】//g' "$FILE"

# 2. 删除√和×符号
echo "2. 删除√和×符号..."
sed -i '' 's/- √ /- /g' "$FILE"
sed -i '' 's/- × /- /g' "$FILE"
sed -i '' 's/√ /✓ /g' "$FILE"
sed -i '' 's/× /✗ /g' "$FILE"

# 3. 删除标题中的括号注释
echo "3. 修改标题格式..."
sed -i '' 's/## 2\.1 Mac本地部署（推荐）/## 2.1 Mac本地部署/g' "$FILE"
sed -i '' 's/## 2\.3 国内一键安装（快速版）/## 2.3 国内一键安装/g' "$FILE"
sed -i '' 's/### Kimi（月之暗面）★ 推荐/### Kimi/g' "$FILE"
sed -i '' 's/### DeepSeek（深度求索）【成本】 最便宜/### DeepSeek/g' "$FILE"

# 4. 修改四级标题为词组形式
echo "4. 修改四级标题..."
sed -i '' 's/#### 为什么推荐Mac/#### Mac推荐理由/g' "$FILE"
sed -i '' 's/#### 为什么推荐飞书（国内）/#### 飞书推荐理由/g' "$FILE"
sed -i '' 's/#### 为什么推荐Telegram（国外）/#### Telegram推荐理由/g' "$FILE"
sed -i '' 's/#### 为什么选择Mac本地部署/#### Mac本地部署优势/g' "$FILE"
sed -i '' 's/#### 为什么选择云端部署/#### 云端部署优势/g' "$FILE"
sed -i '' 's/#### 为什么选择国内版/#### 国内版优势/g' "$FILE"

# 5. 删除Blockquote格式的提示
echo "5. 删除Blockquote格式..."
sed -i '' 's/^> 【Mac】 /注意：/g' "$FILE"
sed -i '' 's/^> 【云端】 /注意：/g' "$FILE"
sed -i '' 's/^> 【国内】 /注意：/g' "$FILE"
sed -i '' 's/^> 【文档】 /注意：/g' "$FILE"
sed -i '' 's/^> /注意：/g' "$FILE"

# 6. 替换口语化表述
echo "6. 替换口语化表述..."
sed -i '' 's/如果你拥有Mac电脑，那么恭喜你！/Mac电脑用户可以选择本地部署方式。/g' "$FILE"
sed -i '' 's/让我们一步步完成安装/按照以下步骤完成安装/g' "$FILE"
sed -i '' 's/让我们回顾一下本章的核心内容/本章核心内容回顾如下/g' "$FILE"
sed -i '' 's/接下来让我们/接下来/g' "$FILE"
sed -i '' 's/让我们/下面/g' "$FILE"

# 7. 为代码块添加引出语
echo "7. 规范代码引出方式..."
# 这个需要手动处理，因为需要判断是命令还是代码

echo ""
echo "✓ 第2章格式修复完成！"
echo ""
echo "还需要手动处理的问题："
echo "  1. 为所有图片添加编号（图2-1、图2-2...）"
echo "  2. 在正文中添加图片引用（如图2-1所示）"
echo "  3. 将图题移到图片下方"
echo "  4. 为表格添加编号（表2-1、表2-2...）"
echo "  5. 在正文中添加表格引用（见表2-1）"
echo "  6. 为代码块添加'代码如下：'或'命令如下：'"
echo "  7. 检查并翻译图片中的英文"
echo ""
