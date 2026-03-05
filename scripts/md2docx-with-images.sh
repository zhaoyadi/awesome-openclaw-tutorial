#!/bin/bash

# 重新转换第1-5章的DOCX,确保图片正确嵌入

echo "开始转换第1-5章,下载并嵌入图片..."

# 创建临时目录存放下载的图片
MEDIA_DIR="output/media"
mkdir -p "$MEDIA_DIR"

# 转换第1章
echo "转换第1章..."
pandoc docs/01-basics/01-introduction.md \
  -o output/chapters/第1章-OpenClaw简介.docx \
  --from markdown \
  --to docx \
  --extract-media="$MEDIA_DIR/ch01"

# 转换第2章
echo "转换第2章..."
pandoc docs/01-basics/02-installation.md \
  -o output/chapters/第2章-安装与配置.docx \
  --from markdown \
  --to docx \
  --extract-media="$MEDIA_DIR/ch02"

# 转换第3章
echo "转换第3章..."
pandoc docs/01-basics/03-advanced-deployment.md \
  -o output/chapters/第3章-高级部署.docx \
  --from markdown \
  --to docx \
  --extract-media="$MEDIA_DIR/ch03"

# 转换第4章
echo "转换第4章..."
pandoc docs/01-basics/04-maintenance-upgrade.md \
  -o output/chapters/第4章-维护与升级.docx \
  --from markdown \
  --to docx \
  --extract-media="$MEDIA_DIR/ch04"

# 转换第5章
echo "转换第5章..."
pandoc docs/01-basics/05-quick-start.md \
  -o output/chapters/第5章-快速上手.docx \
  --from markdown \
  --to docx \
  --extract-media="$MEDIA_DIR/ch05"

echo "✓ 转换完成!"
echo "✓ 图片已下载到: $MEDIA_DIR"
echo "✓ DOCX文件位于: output/chapters/"
