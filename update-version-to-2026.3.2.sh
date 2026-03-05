#!/bin/bash

# 更新 OpenClaw 版本引用到 2026.3.2

TARGET_DIR="awesome-openclaw-tutorial/docs"
OLD_VERSION="2026\.2\.9"
NEW_VERSION="2026.3.2"
OLD_PROBLEM_VERSION="2026\.2\.12"
NEW_PROBLEM_VERSION="2026.2.12"  # 保持问题版本不变，只是更新说明

echo "开始更新版本引用..."
echo "目标目录: $TARGET_DIR"
echo "旧版本: 2026.2.9 -> 新版本: 2026.3.2"
echo ""

# 备份
BACKUP_DIR="awesome-openclaw-tutorial/backups/version-update-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r "$TARGET_DIR" "$BACKUP_DIR/"
echo "✅ 已备份到: $BACKUP_DIR"
echo ""

# 查找并替换所有 .md 文件中的版本号
find "$TARGET_DIR" -name "*.md" -type f | while read -r file; do
    if grep -q "$OLD_VERSION" "$file"; then
        echo "更新文件: $file"
        # macOS 使用 sed -i '' 语法
        sed -i '' "s/$OLD_VERSION/$NEW_VERSION/g" "$file"
    fi
done

echo ""
echo "✅ 版本更新完成！"
echo ""
echo "更新统计："
grep -r "2026\.3\.2" "$TARGET_DIR" --include="*.md" | wc -l | xargs echo "- 新版本引用数量:"
grep -r "2026\.2\.12" "$TARGET_DIR" --include="*.md" | wc -l | xargs echo "- 问题版本引用数量:"

