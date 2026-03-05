#!/bin/bash

# 使用目录-修订.docx模板批量转换所有章节

TEMPLATE="output/chapters/目录-修订.docx"
MEDIA_DIR="output/media"

echo "开始使用模板转换所有章节..."
echo "模板文件: $TEMPLATE"
echo ""

# 检查模板文件是否存在
if [ ! -f "$TEMPLATE" ]; then
    echo "❌ 错误: 模板文件不存在: $TEMPLATE"
    exit 1
fi

# 创建媒体目录
mkdir -p "$MEDIA_DIR"

# 计数器
total=0
success=0
failed=0

# 转换所有章节
for file in docs/*/*.md; do
    if [ -f "$file" ] && [[ ! "$file" =~ \.backup$ ]] && [[ ! "$file" =~ \.emoji-backup$ ]]; then
        # 提取章节信息
        dir=$(dirname "$file")
        filename=$(basename "$file" .md)
        
        # 提取章节号(如果有)
        if [[ "$filename" =~ ^([0-9]+)- ]]; then
            chapter_num="${BASH_REMATCH[1]}"
            chapter_name=$(echo "$filename" | sed 's/^[0-9]*-//')
            output_name="第${chapter_num}章-${chapter_name}.docx"
            media_subdir="ch${chapter_num}"
        else
            output_name="${filename}.docx"
            media_subdir="${filename}"
        fi
        
        output_file="output/chapters/${output_name}"
        
        echo "转换: $filename"
        
        # 执行转换
        if pandoc "$file" \
            -o "$output_file" \
            --from markdown \
            --to docx \
            --reference-doc="$TEMPLATE" \
            --extract-media="${MEDIA_DIR}/${media_subdir}" \
            2>/dev/null; then
            echo "  ✓ 成功: $output_name"
            ((success++))
        else
            echo "  ❌ 失败: $output_name"
            ((failed++))
        fi
        
        ((total++))
    fi
done

echo ""
echo "================================"
echo "转换完成!"
echo "总计: $total 个文件"
echo "成功: $success 个"
echo "失败: $failed 个"
echo "================================"
echo ""
echo "输出目录: output/chapters/"
echo "图片目录: output/media/"
