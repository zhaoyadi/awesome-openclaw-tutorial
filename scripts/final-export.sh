#!/bin/bash

# 最终导出脚本 - 使用模板批量转换所有章节到新文件夹

TEMPLATE="output/chapters/目录-修订.docx"
OUTPUT_DIR="output-final"
DOCX_DIR="${OUTPUT_DIR}/docx"
MEDIA_DIR="${OUTPUT_DIR}/media"
REPORTS_DIR="${OUTPUT_DIR}/reports"

echo "========================================="
echo "OpenClaw教程 - 最终导出"
echo "========================================="
echo ""

# 检查模板文件
if [ ! -f "$TEMPLATE" ]; then
    echo "❌ 错误: 模板文件不存在: $TEMPLATE"
    exit 1
fi

echo "✓ 模板文件: $TEMPLATE"
echo "✓ 输出目录: $OUTPUT_DIR"
echo ""

# 清理并创建目录
rm -rf "$OUTPUT_DIR"
mkdir -p "$DOCX_DIR" "$MEDIA_DIR" "$REPORTS_DIR"

# 复制模板到输出目录
cp "$TEMPLATE" "$DOCX_DIR/00-模板.docx"

# 计数器
total=0
success=0
failed=0

echo "开始转换章节..."
echo ""

# 按顺序转换所有章节
for file in docs/*/*.md; do
    if [ -f "$file" ] && [[ ! "$file" =~ \.backup$ ]] && [[ ! "$file" =~ \.emoji-backup$ ]]; then
        filename=$(basename "$file" .md)
        
        # 提取章节号
        if [[ "$filename" =~ ^([0-9]+)- ]]; then
            chapter_num="${BASH_REMATCH[1]}"
            chapter_name=$(echo "$filename" | sed 's/^[0-9]*-//')
            output_name="第${chapter_num}章-${chapter_name}.docx"
            media_subdir="ch${chapter_num}"
            display_name="第${chapter_num}章"
        else
            output_name="${filename}.docx"
            media_subdir="${filename}"
            display_name="${filename}"
        fi
        
        output_file="${DOCX_DIR}/${output_name}"
        
        echo -n "[$((total+1))] 转换 ${display_name}... "
        
        # 执行转换
        if pandoc "$file" \
            -o "$output_file" \
            --from markdown \
            --to docx \
            --reference-doc="$TEMPLATE" \
            --extract-media="${MEDIA_DIR}/${media_subdir}" \
            2>/dev/null; then
            
            # 获取文件大小
            size=$(ls -lh "$output_file" | awk '{print $5}')
            echo "✓ ($size)"
            ((success++))
        else
            echo "❌ 失败"
            ((failed++))
        fi
        
        ((total++))
    fi
done

echo ""
echo "========================================="
echo "转换完成!"
echo "========================================="
echo "总计: $total 个文件"
echo "成功: $success 个"
echo "失败: $failed 个"
echo ""

# 生成文件清单
echo "生成文件清单..."

cat > "${REPORTS_DIR}/文件清单.txt" << EOF
OpenClaw教程 - 最终交付文件清单
生成时间: $(date '+%Y-%m-%d %H:%M:%S')

========================================
一、DOCX文件 (${DOCX_DIR})
========================================

EOF

ls -lh "$DOCX_DIR" | grep "\.docx$" | awk '{printf "%-50s %8s\n", $9, $5}' >> "${REPORTS_DIR}/文件清单.txt"

cat >> "${REPORTS_DIR}/文件清单.txt" << EOF

========================================
二、图片文件 (${MEDIA_DIR})
========================================

EOF

find "$MEDIA_DIR" -type f | wc -l | xargs echo "图片总数:" >> "${REPORTS_DIR}/文件清单.txt"
du -sh "$MEDIA_DIR" | awk '{print "总大小:", $1}' >> "${REPORTS_DIR}/文件清单.txt"

echo ""
echo "========================================="
echo "输出位置"
echo "========================================="
echo "DOCX文件: $DOCX_DIR"
echo "图片文件: $MEDIA_DIR"
echo "报告文件: $REPORTS_DIR"
echo ""
echo "✓ 完成!"
