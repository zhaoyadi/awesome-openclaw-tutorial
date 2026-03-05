#!/bin/bash

# 检查简单罗列问题的脚本
# 识别过度使用列表、缺乏过渡语的章节

echo "# 简单罗列问题检查报告"
echo ""
echo "检查时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
echo "---"
echo ""

for file in $(find awesome-openclaw-tutorial/docs -name "*.md" -type f | sort); do
    filename=$(basename "$file")
    chapter_num=$(echo "$filename" | grep -oE '^[0-9]+')
    
    # 统计列表项数量
    list_items=$(grep -c '^- ' "$file" || echo 0)
    
    # 统计连续列表（3行以上）
    continuous_lists=$(awk '/^- / {count++} !/^- / && count >= 3 {print count; count=0} END {if (count >= 3) print count}' "$file" | wc -l)
    
    # 统计小标题数量（### 和 ####）
    h3_count=$(grep -c '^### ' "$file" || echo 0)
    h4_count=$(grep -c '^#### ' "$file" || echo 0)
    
    # 统计段落数量（非空行、非列表、非标题）
    paragraphs=$(grep -v '^$' "$file" | grep -v '^#' | grep -v '^-' | grep -v '^>' | grep -v '^```' | grep -v '^|' | wc -l)
    
    # 计算列表与段落的比例
    if [ "$paragraphs" -gt 0 ]; then
        ratio=$(echo "scale=2; $list_items / $paragraphs" | bc)
    else
        ratio="N/A"
    fi
    
    echo "## 第${chapter_num}章: $filename"
    echo ""
    echo "- 列表项总数: $list_items"
    echo "- 连续列表块: $continuous_lists"
    echo "- 三级标题: $h3_count"
    echo "- 四级标题: $h4_count"
    echo "- 段落数: $paragraphs"
    echo "- 列表/段落比: $ratio"
    echo ""
    
    # 判断是否存在严重罗列问题
    if [ "$list_items" -gt 100 ] && [ "$continuous_lists" -gt 10 ]; then
        echo "🔴 **严重问题**: 列表项过多（$list_items项），连续列表块多（$continuous_lists块）"
        echo ""
    elif [ "$list_items" -gt 50 ] && [ "$continuous_lists" -gt 5 ]; then
        echo "🟡 **中等问题**: 列表项较多（$list_items项），建议增加过渡语"
        echo ""
    fi
    
    # 检查是否有过多的小标题
    total_headings=$((h3_count + h4_count))
    if [ "$total_headings" -gt 30 ]; then
        echo "⚠️  **标题过多**: 三四级标题共$total_headings个，可能导致内容碎片化"
        echo ""
    fi
    
    echo "---"
    echo ""
done

echo ""
echo "# 检查完成"
echo ""
echo "说明："
echo "- 🔴 严重问题：需要大幅改写，增加段落叙述和过渡语"
echo "- 🟡 中等问题：需要适度增加过渡语和连接句"
echo "- ⚠️  标题过多：考虑合并部分小节，减少碎片化"
