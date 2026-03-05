#!/bin/bash

echo "# 章节内容质量检查报告"
echo ""
echo "检查时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
echo "---"
echo ""

for file in $(find awesome-openclaw-tutorial/docs -name "*.md" -type f | sort); do
    filename=$(basename "$file")
    chapter_num=$(echo "$filename" | grep -oE '^[0-9]+')
    
    # 统计行数
    total_lines=$(wc -l < "$file")
    
    # 统计字数（中文字符）
    chinese_chars=$(grep -o '[一-龥]' "$file" | wc -l)
    
    # 统计标题数量
    h1_count=$(grep -c '^# ' "$file" || echo 0)
    h2_count=$(grep -c '^## ' "$file" || echo 0)
    h3_count=$(grep -c '^### ' "$file" || echo 0)
    
    # 统计代码块数量
    code_blocks=$(grep -c '^```' "$file" || echo 0)
    code_blocks=$((code_blocks / 2))
    
    # 统计图片数量
    images=$(grep -c '!\[' "$file" || echo 0)
    
    # 检查是否有emoji
    has_emoji=$(grep -E '(√|×|【|】|★|☆|✓|✗|➜|→|←|↑|↓|⚠|⚡|🎯|📝|💡|🔧|🚀|⭐)' "$file" && echo "是" || echo "否")
    
    # 检查是否有简单罗列（连续3行以上的短句）
    short_lines=$(awk 'length($0) < 30 && length($0) > 0' "$file" | wc -l)
    
    echo "## 第${chapter_num}章: $filename"
    echo ""
    echo "- 总行数: $total_lines"
    echo "- 中文字数: $chinese_chars"
    echo "- 标题数: H1=$h1_count, H2=$h2_count, H3=$h3_count"
    echo "- 代码块: $code_blocks"
    echo "- 图片: $images"
    echo "- 包含emoji/符号: $has_emoji"
    echo "- 短行数量: $short_lines"
    echo ""
    
    # 判断内容是否过少
    if [ "$chinese_chars" -lt 3000 ]; then
        echo "⚠️  **警告**: 内容较少（少于3000字），建议扩充"
        echo ""
    fi
    
    # 判断是否可能存在简单罗列
    if [ "$short_lines" -gt 50 ]; then
        echo "⚠️  **警告**: 短行较多（$short_lines行），可能存在简单罗列，建议增加过渡语"
        echo ""
    fi
    
    echo "---"
    echo ""
done

echo ""
echo "# 总结"
echo ""
echo "检查完成！请重点关注标记为⚠️的章节。"
